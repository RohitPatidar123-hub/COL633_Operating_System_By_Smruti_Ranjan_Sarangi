#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

#ifndef ALPHA
#define ALPHA 0.5
#endif

#ifndef BETA
#define BETA 0.5
#endif

#ifndef MAX_PRIORITY
#define MAX_PRIORITY 100
#endif
#ifndef WAIT_THRESHOLD
#define WAIT_THRESHOLD 100
#endif

#ifndef INITPRIO
#define INITPRIO 10
#endif

#define MIN_CPU_HOLD_TICKS 2

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->suspended=0;

  p->priority_0 = 16;      
  p->end_time = 0;
  p->start_time = 0;
  p->start_later = 0;
  p->exec_time = -1;
  p->sleeping_time = 0;
  p->cpu_ticks = 0;
  p->wait_time = 0;
  p->ncs = 0;
  p->creation_time = ticks; 
  p->total_sleeping_time = 0;
  


  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  //cprintf("exit(): process %d (%s) exiting\n", curproc->pid, curproc->name);
  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }


curproc->state = ZOMBIE;
curproc->end_time = ticks;


int turnaround = curproc->end_time - curproc->creation_time;     
int response   = curproc->start_time - curproc->creation_time;      
int waiting    = turnaround - curproc->cpu_ticks - curproc->total_sleeping_time;

cprintf("PID: %d\n", curproc->pid);
cprintf("TAT: %d\n", turnaround);
cprintf("WT: %d\n", waiting);
cprintf("RT: %d\n", response);
cprintf("#CS: %d\n", curproc->ncs);
    
sched();
panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.

void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  if(myproc()->state == SUSPENDED){
    sched();
  }else{
    myproc()->state = RUNNABLE;
    sched();
  }

  release(&ptable.lock);
}

void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {

    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  } 
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  int start_sleep_time = ticks;

  sched();

  p->total_sleeping_time += ticks - start_sleep_time;
  // Tidy up.
  p->chan = 0;

   if(p->killed){
        release(&ptable.lock);
        exit();
    }

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
   { 
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
             {   
               p->state = RUNNABLE;
             }
   }   
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [WAITING_TO_START]  "wait_to_start ",
  [RUNNABLE]  "runnble",
  [RUNNING]   "running   ",
  [ZOMBIE]    "zombie",
  [STOPPED]   "stopped",
  [SUSPENDED] "suspended"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}



void wakeup_shell(void) {
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == 2){  // shell is typically pid 2
      p->state = RUNNABLE;
      cprintf("Shell (pid=%d) explicitly woken up\n", p->pid);
      break;
    }
  }
  release(&ptable.lock);
}


void send_signal_to_all(int sig){
    struct proc *p;
    //int should_resume_shell = 0;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
         if (p->pid == 1 ) continue;
         if (p->pid == 2){
            p->suspended = 0;
            p->state = RUNNABLE;
            continue;
         }
         if(p->state == UNUSED ){
            continue;
         }
        //  cprintf("SIG %d to pid=%d name=%s state=%d\n", sig, p->pid, p->name, p->state);
          switch(sig) {
            case SIGINT:
                p->killed = 1;   // terminate the process
                if(p->state == SLEEPING || p->state == SUSPENDED || p->state == WAITING_TO_START  || p->state == RUNNABLE)
                    p->state = RUNNABLE; // explicitly wake up to terminate
                // cprintf(" -> Terminatedc pid=%d name=%s\n", p->pid, p->name);    
                break;

            case SIGBG:
                  if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING || p->state == WAITING_TO_START || p->state == STOPPED){
                      p->state = SUSPENDED;
                      p->suspended = 1;
                      //should_resume_shell = 1;
                      // cprintf(" -> Suspended pid=%d name=%s and the state is=%d\n", p->pid, p->name, p->state);
                    }
                    struct proc *itr;
                    for(itr = ptable.proc; itr < &ptable.proc[NPROC]; itr++){
                      if(itr->pid > 2 ){
                        itr->parent = initproc;
                      }
                    }
                  break;

            case SIGFG:
                  if(p->state == SUSPENDED)
                    { 
                     p->suspended = 0;  
                     p->state = RUNNABLE;  // resume suspended process
                    //  cprintf(" -> Resumed pid=%d name=%s\n", p->pid, p->name);  
                    }
                  break;

            case SIGCUSTOM:
                 if(p->signal_handler){
                     p->pending_signal = SIGCUSTOM;
                     if(p->state == SLEEPING)
                        p->state = RUNNABLE;
                }
                break;
        }       
    }
     wakeup1(ptable.proc+1);// wake up shell
    // cprintf("The state of shell is %d", (ptable.proc+1)->state);
    release(&ptable.lock);
}


void  signal_to_all(int sig ,struct proc * p){
                p->killed = 1;   // terminate the process
                if(p->state == SLEEPING || p->state == SUSPENDED || p->state == WAITING_TO_START  || p->state == RUNNABLE)
                    p->state = ZOMBIE; // explicitly wake up to terminate
                cprintf(" -> Terminatedc pid=%d name=%s\n", p->pid, p->name);
};


void scheduler(void)
{
  struct proc *p, *bestProcess, *lastProcess = 0; 
  struct cpu *c = mycpu();
  float bestValue;
  float priority_val;

  c->proc = 0;

  for(;;){
    sti();
    acquire(&ptable.lock);

    bestProcess = 0;
    bestValue = -1e9;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      if(p->suspended == 1 || p->state == SUSPENDED)
        continue;

      if(p->state == RUNNABLE)
        p->wait_time++;

      if(p->wait_time >= WAIT_THRESHOLD)
        priority_val = MAX_PRIORITY;
      else {
        priority_val = (float)p->priority_0
                       - ALPHA * (float)p->cpu_ticks
                       + BETA  * (float)p->wait_time;
        if(priority_val > MAX_PRIORITY)
          priority_val = MAX_PRIORITY;
      }

      if(bestProcess == 0 || priority_val > bestValue ||
         (priority_val == bestValue && p->pid < bestProcess->pid)) {
        bestProcess = p;
        bestValue = priority_val;
      }
    }

    if(bestProcess != 0 ){
      bestProcess->wait_time = 0;
      c->proc = bestProcess;
      switchuvm(bestProcess);
      bestProcess->state = RUNNING;

      if(bestProcess->start_time == 0)
        bestProcess->start_time = ticks;

      swtch(&(c->scheduler), bestProcess->context);
      switchkvm();
      c->proc = 0;

      if (lastProcess && bestProcess != lastProcess)
        lastProcess->ncs++;

      lastProcess = bestProcess; 
    }

    release(&ptable.lock);
  }
}
