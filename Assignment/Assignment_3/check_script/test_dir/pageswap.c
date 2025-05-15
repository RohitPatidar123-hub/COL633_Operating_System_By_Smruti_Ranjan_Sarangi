#include "types.h"
#include "param.h"      // NCPU, NOFILE
#include "mmu.h"        // pte_t, PTE_*, PGSIZE
#include "defs.h"       // walkpgdir(), cprintf, etc.
#include "proc.h"       // struct proc, ptable extern
#include "memlayout.h"
#include "fs.h"         // for struct buf, bread(), brelse()
#include "spinlock.h"
#include "swap.h"
/* ptable is defined as a static struct in proc.c; we must forward-declare
   it so we can lock it here.  (Layout matches the definition in proc.c.) */
// extern struct {
//   struct spinlock lock;
//   struct proc     proc[NPROC];
// } ptable;








// void  init_swap(void);     // called once at boot

void  maybe_swap(void);    // called from kalloc() when free_pages == 0



// void
// swap_in_page(struct proc *p, uint va)
// {
//   pte_t *pte = walkpgdir(p->pgdir, (void*)va, 0);
//   if(!pte || (*pte & PTE_P) || *pte == 0)
//     panic("swap_in_page: invalid page");

//   // extract slot index (we stored it in the PTE’s high bits on swap-out)
//   int slot = PTE_ADDR(*pte) >> 12;

//   // allocate a fresh physical page
//   char *mem = kalloc();
//   if(mem == 0)
//     panic("swap_in_page: out of memory");

//   // read back the 8 blocks (4096 bytes)
//   for(int i = 0; i < 8; i++){
//     struct buf *b = bread(ROOTDEV, SWAP_START + slot*8 + i);
//     memmove(mem + i*512, b->data, 512);
//     brelse(b);
//   }

//   // restore PTE: physical addr | original perms | present
//   uint pa = V2P(mem);
//   int perm = swap_slots[slot].page_perm;
//   *pte = pa | perm | PTE_P;

//   // free the swap slot
// //   acquire(&slock);
//   swap_slots[slot].is_free = 1;
// //   release(&slock);

//   // update process’s RSS
//   p->rss++;
// }


void
maybe_swap(void)
{
  // Step 2.2: nothing yet – will contain adaptive algorithm in Step 2.5
}

// Pick the process with largest rss (tie → lower pid)
// struct proc*
// select_victim_proc(void)
// {
//   struct proc *best = 0;
//   int maxrss = -1;

//    acquire(&ptable.lock);
//   for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//     if(p->state!=RUNNING && p->state!=RUNNABLE && p->state!=SLEEPING)
//       continue;
//     if(p->pid > 0){
//       if(p->rss > maxrss
//          || (p->rss == maxrss && p->pid < best->pid)){
//         best = p;
//         maxrss = p->rss;
//       }
//     }
//   }
//    release(&ptable.lock);
//   return best;    // may be 0 if no candidates
// }

// Within p’s address space, find a PTE with PTE_P=1, PTE_A=0.
// If none, clear all PTE_A bits on first pass and pick first present page.
void
select_victim_page(struct proc *p, uint *vaddr, pde_t **ppte)
{
  // 1st pass: unaccessed page
  for(uint a = 0; a < p->sz; a += 4096){
    pte_t *pte = walkpgdir(p->pgdir, (void*)a, 0);
    if(pte && (*pte & PTE_P) && !(*pte & PTE_A)){
      *vaddr = a;
      *ppte  = pte;
      return;
    }
  }
  // 2nd pass: clear accessed bits, then pick first present
  for(uint a = 0; a < p->sz; a += 4096){
    pte_t *pte = walkpgdir(p->pgdir, (void*)a, 0);
    if(pte && (*pte & PTE_P)){
      *pte &= ~PTE_A;  // reset for next cycle
      *vaddr = a;
      *ppte  = pte;
      return;
    }
  }
  // no present pages at all? unlikely, but safe default
  *vaddr = 0;
  *ppte  = 0;
}

void
init_swap(void)
{
//   initlock(&slock, "swap");
//   acquire(&slock);
  for(int i = 0; i < SWAP_SLOTS; i++){
    swap_slots[i].is_free   = 1;
    swap_slots[i].page_perm = 0;
  }
//   release(&slock);
}