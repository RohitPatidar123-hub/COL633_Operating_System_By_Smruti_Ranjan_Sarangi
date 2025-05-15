#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"  // for struct sleeplock
#include "buf.h"


struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static int  alloc_swap_slot(int pid, uint va, int perm);
static void write_swap_page(int slot, char *pa);
static void read_swap_page(int slot, char *pa);

// Adaptive swap policy parameters
#ifndef ALPHA
#define ALPHA 25
#endif
#ifndef BETA
#define BETA 10
#endif
static int Th    = 100;   // threshold: free pages < Th triggers swap
static int Npg   = 2;     // pages to swap out each time
static int Limit = 100;   // maximum Npg

// Forward declarations
static int  alloc_swap_slot(int pid, uint va, int perm);
static void write_swap_page(int slot, char *pa);
static void read_swap_page(int slot, char *pa);
static struct proc* select_victim_proc(void);
static uint        select_victim_va(struct proc *victim);
static void        swap_out_pages(int n);
void               handle_page_fault(uint fault_va);

// Swap-slot bookkeeping
struct swap_slot {
  int is_free;    // 1 if free
  int perm;       // saved PTE permissions
  uint va;        // user VA
  int pid;        // owner pid
};
static struct swap_slot swap_table[NSPAGESLOTS];
static struct spinlock swaplock;

// Initialize swap slots; call at boot
void
init_swap(void)
{
  initlock(&swaplock, "swap");
  for(int i = 0; i < NSPAGESLOTS; i++){
    swap_table[i].is_free = 1;
    swap_table[i].perm    = 0;
    swap_table[i].va      = 0;
    swap_table[i].pid     = 0;
  }
}

// Free slots for pid; call on exit
void
cleanup_swap_slots(int pid)
{
  acquire(&swaplock);
  for(int i = 0; i < NSPAGESLOTS; i++){
    if(!swap_table[i].is_free && swap_table[i].pid == pid)
      swap_table[i].is_free = 1;
  }
  release(&swaplock);
}

// Allocate first free swap slot
static int
alloc_swap_slot(int pid, uint va, int perm)
{
  acquire(&swaplock);
  for(int i = 0; i < NSPAGESLOTS; i++){
    if(swap_table[i].is_free){
      swap_table[i].is_free = 0;
      swap_table[i].pid     = pid;
      swap_table[i].va      = va;
      swap_table[i].perm    = perm;
      release(&swaplock);
      return i;
    }
  }
  release(&swaplock);
  return -1;
}

// Write a 4KiB page (8 blocks) from pa into swap slot
static void
write_swap_page(int slot, char *pa)
{
  int startb = (FSSIZE - SWAP_BLOCKS) + slot * PAGES_PER_SLOT;
  for(int i = 0; i < PAGES_PER_SLOT; i++){
    int blkno = startb + i;
    struct buf *b = bread(ROOTDEV, blkno);
    memmove(b->data, pa + i*BSIZE, BSIZE);
    bwrite(b);
    brelse(b);
  }
}

// Read a 4KiB page (8 blocks) into pa
static void
read_swap_page(int slot, char *pa)
{
  int startb = (FSSIZE - SWAP_BLOCKS) + slot * PAGES_PER_SLOT;
  for(int i = 0; i < PAGES_PER_SLOT; i++){
    int blkno = startb + i;
    struct buf *b = bread(ROOTDEV, blkno);
    memmove(pa + i*BSIZE, b->data, BSIZE);
    brelse(b);
  }
}

// Select process with highest rss (tie: lower pid)
static struct proc*
select_victim_proc(void)
{
  struct proc *best = 0;
  acquire(&ptable.lock);
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state!=RUNNING && p->state!=RUNNABLE && p->state!=SLEEPING)
      continue;
    if(p->pid < 1) continue;
    if(!best || p->rss > best->rss || (p->rss==best->rss && p->pid<best->pid))
      best = p;
  }
  release(&ptable.lock);
  return best;
}

// Select a cold victim VA: PTE_P|PTE_U|PTE_W && !PTE_A
static uint
select_victim_va(struct proc *victim)
{
  pte_t *pte;
  // pass 1: find cold writable page
  for(uint va = 0; va < victim->sz; va += PGSIZE){
    pde_t *pde = &victim->pgdir[PDX(va)];
    if(!(*pde & PTE_P)) continue;
    pte = (pte_t*)P2V(PTE_ADDR(*pde)) + PTX(va);
    if((*pte & (PTE_P|PTE_U|PTE_W)) == (PTE_P|PTE_U|PTE_W)
       && !(*pte & PTE_A))
      return va;
  }
  // pass 2: clear A, then pick first writable
  for(uint va = 0; va < victim->sz; va += PGSIZE){
    pde_t *pde = &victim->pgdir[PDX(va)];
    if(!(*pde & PTE_P)) continue;
    pte = (pte_t*)P2V(PTE_ADDR(*pde)) + PTX(va);
    if(*pte & (PTE_P|PTE_U|PTE_W))
      *pte &= ~PTE_A;
  }
  for(uint va = 0; va < victim->sz; va += PGSIZE){
    pde_t *pde = &victim->pgdir[PDX(va)];
    if(!(*pde & PTE_P)) continue;
    pte = (pte_t*)P2V(PTE_ADDR(*pde)) + PTX(va);
    if(*pte & (PTE_P|PTE_U|PTE_W))
      return va;
  }
  return (uint)-1;  // should not happen
}

// Evict up to n pages
static void
swap_out_pages(int n)
{
  for(int i = 0; i < n; i++){
    struct proc *p = select_victim_proc();
    if(!p) break;
    uint va = select_victim_va(p);
    if(va == (uint)-1) break;
    pte_t *pte = walkpgdir(p->pgdir, (void*)va, 0);
    int perm = *pte & 0xFFF;
    *pte &= ~(PTE_P | PTE_U);
    int slot = alloc_swap_slot(p->pid, va, perm);
    write_swap_page(slot, (char*)P2V(PTE_ADDR(*pte)));
    kfree((char*)P2V(PTE_ADDR(*pte)));
    p->rss--;
  }
}

// Page-fault handler: swap-in
void
handle_page_fault(uint fault_va)
{
  uint va = PGROUNDDOWN(fault_va);
  int slot = -1;
  acquire(&swaplock);
  for(int i=0; i<NSPAGESLOTS; i++){
    if(!swap_table[i].is_free
       && swap_table[i].pid==myproc()->pid
       && swap_table[i].va==va){
      slot = i;
      break;
    }
  }
  if(slot<0){ release(&swaplock); panic("page fault: not swapped"); }
  int perm = swap_table[slot].perm;
  swap_table[slot].is_free = 1;
  release(&swaplock);
  char *mem = kalloc();
  if(mem==0){
    swap_out_pages(Npg);
    mem = kalloc();
    if(mem==0) panic("handle_page_fault: kalloc");
  }
  read_swap_page(slot, mem);
  if(mappages(myproc()->pgdir, (char*)va, PGSIZE,
              V2P(mem), perm|PTE_P|PTE_U) != 0)
    panic("handle_page_fault: mappages");
  myproc()->rss++;
}

// Allocate user memory from oldsz to newsz
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;
  if(newsz >= KERNBASE) return 0;
  if(newsz < oldsz) return oldsz;
  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("Current Threshold = %d, Swapping %d pages\n", Th, Npg);
      swap_out_pages(Npg);
      Th  = Th  * (100 - BETA) / 100;
      Npg = (Npg * (100 + ALPHA) / 100 > Limit)
              ? Limit
              : (Npg * (100 + ALPHA) / 100);
      mem = kalloc();
      if(mem == 0){ deallocuvm(pgdir, newsz, oldsz); return 0; }
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
    myproc()->rss++;
  }
  return newsz;
}

// Deallocate user pages
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;
  if(newsz >= oldsz) return oldsz;
  a = PGROUNDUP(newsz);
  for(; a < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (void*)a, 0);
    if(!pte){ a = PGADDR(PDX(a)+1,0,0) - PGSIZE; continue; }
    if(*pte & PTE_P){
      pa = PTE_ADDR(*pte);
      char *v = P2V(pa);
      kfree(v);
      myproc()->rss--;
      *pte = 0;
    }
  }
  return newsz;
}
