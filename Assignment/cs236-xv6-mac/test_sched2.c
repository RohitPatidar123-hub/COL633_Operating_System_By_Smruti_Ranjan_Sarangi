#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int pid = custom_fork(1, 50);  // start later, run indefinitely
    if (pid < 0) {
        printf(1, "Fork failed\n");
        exit();
    } else if (pid == 0) {
        // Child process branch
        printf(1, "[Child] I'm starting now (PID: %d)\n", getpid());
        // Run indefinitely
        // while(1) {
        //     printf(1, "[Child] Running...\n");
        // } 
         for (volatile int j = 0; j < 10000000; j++); // Simulated work
        exit();
    } else {
        // Parent process branch
        printf(1, "[Parent] Child created with PID %d (start later)\n", pid);
        // sleep(100);
        scheduler_start();  // Now allow the delayed child to run
        printf(1, "[Parent] Called scheduler_start\n");
        // wait();
    }
    exit();
}
