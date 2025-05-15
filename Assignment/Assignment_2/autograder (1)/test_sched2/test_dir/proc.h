#define SIGINT     1  // Ctrl+C
#define SIGBG      2  // Ctrl+B
#define SIGFG      3  // Ctrl+F
#define SIGCUSTOM  4  // Ctrl+G


struct cpu {
  uchar apicid;                
  struct context *scheduler;   
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   
  volatile uint started;       
  int ncli;                    
  int intena;                  
  struct proc *proc;           
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

enum procstate { UNUSED, EMBRYO, SLEEPING,WAITING_TO_START, RUNNABLE, RUNNING, ZOMBIE , STOPPED, SUSPENDED};

// Per-process state
struct proc {
  uint sz;                
  int control_flag;          
  int pending_signal;                 
  void (*signal_handler)(void);        
  int suspended; 
  int in_signal_handler;        
  uint backup_eip;             
  int in_handler;        



    int start_later;        
    int exec_time;            
  


  int first_run_time;      
  int total_run_time;     
  int total_wait_time;    
  int context_switches;    
  int has_started;         
  int start_run_tick;         
  int sum_running;
  int sleeping_time;
  int total_sleeping_time;


  int priority_0;    
  int cpu_ticks;     
  int wait_time;     

  uint end_time;        
  uint start_time;  
  int ncs;           
  uint creation_time;          

  int last_start_tick;
  //................................
    //part 2.3
    

  //.................................

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
