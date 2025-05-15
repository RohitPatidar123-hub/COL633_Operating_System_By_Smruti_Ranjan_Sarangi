#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_PROCS 4  // Number of processes to create

int main() {
    int proc[NUM_PROCS][2] ={   {1, 5},
                                {1, 10},
                                {1, 5},
                                {1, -1}
                            };
    int sys_scheduler_uptime = 2147483647;
    // Create child processes using custom_fork
    for (int i = 0; i < NUM_PROCS; i++) {
        sleep(5);
        int pid = custom_fork(proc[i][0], proc[i][1]);
        if (pid < 0) {
            printf(1, "Failed to fork process %d\n", i);
            exit();
        } else if (pid == 0) {
            // Child process with start later =0
            if(proc[i][0] == 0){

                int start = uptime();
                int target = proc[i][1];                
                // Busy-wait until target ticks elapse
                while (uptime() - start < target+10) {
                    volatile int j;
                    for (j = 0; j < 1000; j++);  // Prevent optimization
                }
                exit();
            }
            else { // Child process with start later =1
                if(proc[i][0] != -1)
                {int target = proc[i][1];                
                // Busy-wait until target ticks elapse
                while(sys_scheduler_uptime - uptime()>0) ;
                while (uptime() - sys_scheduler_uptime < target+10) {
                    volatile int j;
                    for (j = 0; j < 1000; j++);  // Prevent optimization
                }
                exit(); }  

                if(proc[i][0] == -1)       {
                    int target = 60;                
                // Busy-wait until target ticks elapse
                while(sys_scheduler_uptime - uptime()>0) ;
                while (uptime() - sys_scheduler_uptime < target+10) {
                    volatile int j;
                    for (j = 0; j < 1000; j++);  // Prevent optimization
                }
                exit(); 
                }
            }

        } else {
            // Parent stores PID
            // pids[i] = pid;

        }
    }

    // printf(1, "All child processes created with start_later flag set.\n");
    sleep(40);
  
    // Start scheduling these processes
    // printf(1, "Calling sys_scheduler_start() to allow execution.\n");
    sys_scheduler_uptime = uptime();
    scheduler_start();

    // Wait for children to finish
    for (int i = 0; i < NUM_PROCS; i++) {
        wait();

    }

    // printf(1, "All child processes completed.\n");
    exit();
}
