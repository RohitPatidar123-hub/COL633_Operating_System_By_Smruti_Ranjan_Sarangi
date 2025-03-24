// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING,WAITING_TO_START ,RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
 
    // New fields for custom scheduling
  int start_later;          // 1 if process should not run until scheduler_start()
  int exec_time;            // Remaining execution time in ticks (-1 means run indefinitely)
  int start_time;           // Time when the process was actually started
 

  // In proc.h, within struct proc:
int creation_time;        // Ticks when process is forked
int start_time;           // Ticks when process runs (on CPU) for the first time
int end_time;             // Ticks when process finishes (exit)
int total_run_time;       // Total CPU ticks used
int num_context_switches; // # of times this process was context-switched to RUNNING

int first_scheduled;      // Flag: 1 if we've scheduled for the first time

// int last_scheduled;       // Ticks when we last scheduled this process
// int total_wait_time;      // Total ticks this process waited in RUNNABLE state
// int num_runnable;         // # of times this process was in RUNNABLE state
// int num_run;              // # of times this process was in RUNNING state
// int num_zombie;           // # of times this process was in ZOMBIE state
// int num_sleep;            // # of times this process was in SLEEPING state
// int num_embryo;           // # of times this process was in EMBRYO state
// int num_waiting;          // # of times this process was in WAITING_TO_START state
// int num_runnable_total;   // Total # of times this process was in RUNNABLE state
// int num_run_total;        // Total # of times this process was in RUNNING state
// int num_zombie_total;     // Total # of times this process was in ZOMBIE state
// int num_sleep_total;      // Total # of times this process was in SLEEPING state
// int num_embryo_total;     // Total # of times this process was in EMBRYO state
// int num_waiting_total;    // Total # of times this process was in WAITING_TO_START state
// int total_wait_time_total; // Total time this process waited in RUNNABLE state
// int total_run_time_total;  // Total CPU ticks used
// int creation_time_total;   // Total ticks when process is forked


  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
