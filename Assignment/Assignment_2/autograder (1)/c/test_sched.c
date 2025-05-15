#include "types.h"
#include "stat.h"
#include "user.h"
// #include <limits.h>

#define NUM_PROCS 4  // Number of processes to create

int main() {
    int count_0_startlater_flag =0;
    int proc[NUM_PROCS][2] ={   {0, 50},
                                {0, 200},
                                {1, 50},
                                {1, 200}
                            };
    int sys_scheduler_uptime = 2147483647;
    // Create child processes using custom_fork
    for (int i = 0; i < NUM_PROCS; i++) {
        int t = i+1;
        int pid = custom_fork(proc[i][0], proc[i][1]);
        if (pid < 0) {
            printf(1, "Failed to fork process %d\n", i);
            exit();
        } else if (pid == 0) {
            // Child process with start later =0
            if(proc[i][0] == 0){

                count_0_startlater_flag += 1;
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
                int target = proc[i][1];                
                // Busy-wait until target ticks elapse
                while(sys_scheduler_uptime - uptime()>0) ;
                while (uptime() - sys_scheduler_uptime < target+10) {
                    volatile int j;
                    for (j = 0; j < 1000; j++);  // Prevent optimization
                }
                exit();           
            }

        } else {
            // Parent stores PID
            // pids[i] = pid;

        }
    }

    // printf(1, "All child processes created with start_later flag set.\n");
    sleep(400);

    for (int i = 0; i < count_0_startlater_flag; i++) {
        wait();

    }    
    // Start scheduling these processes
    // printf(1, "Calling sys_scheduler_start() to allow execution.\n");
    sys_scheduler_uptime = uptime();
    scheduler_start();

    // Wait for children to finish
    for (int i = 0; i < NUM_PROCS-count_0_startlater_flag; i++) {
        wait();

    }

    printf(1, "All child processes completed.\n");
    exit();
}
