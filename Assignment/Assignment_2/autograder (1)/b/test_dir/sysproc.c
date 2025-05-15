#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


int sys_signal(void) {
    void (*handler)(void);
    
    if (argptr(0, (void*)&handler, sizeof(void*)) < 0)
        return -1;

    myproc()->signal_handler = handler;
    return 0;
}

 
int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_custom_fork(void)
{
  int start_later, exec_time;
  if(argint(0, &start_later) < 0)
    return -1;
  if(argint(1, &exec_time) < 0)
    return -1;
    
  cprintf("sys_custom_fork: start_later=%d, exec_time=%d\n", start_later, exec_time);

  int pid = fork();
  if(pid == 0){  // Child process
    struct proc *curproc = myproc();
    curproc->start_later = start_later;
    curproc->exec_time = exec_time;
    if(start_later){
      acquire(&ptable.lock);
      curproc->state = SLEEPING;
      curproc->chan = (void *)"custom_scheduler";
      release(&ptable.lock);
    }
  }
  return pid;
}

int
sys_scheduler_start(void)
{
  cprintf("sys_scheduler_start called\n");
  acquire(&ptable.lock);
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    // Look for processes that are sleeping on the "custom_scheduler" channel.
    if(p->state == SLEEPING && p->chan == (void *)"custom_scheduler"){
      p->state = RUNNABLE;
      p->chan = 0;
    }
  }
  release(&ptable.lock);
  return 0;

}
