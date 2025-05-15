#include "types.h"
#include "user.h"

#define NUM_CHILDREN 3

// Child process that runs indefinitely
void running_process() {
    while(1) { /* Infinite loop */ }
}

// Child process that sleeps
void sleeping_process() {
    sleep(1000000); // Sleep for a very long time
}

int main() {
    int pids[NUM_CHILDREN];

    printf(1, "\nCtrl+I Memory Printer Test\n");
    printf(1, "Press Ctrl+I to see process memory pages\n\n");

    // Create test processes
    for(int i = 0; i < NUM_CHILDREN; i++) {
        int pid = fork();
        if(pid == 0) {
            // Child processes
            if(i == 0) running_process();  // Will stay RUNNABLE/RUNNING
            if(i == 1) sleeping_process(); // Will enter SLEEPING state
            if(i == 2) exit();             // Will become ZOMBIE
        }
        pids[i] = pid;
    }

    // Parent process instructions
    printf(1, "Process hierarchy:\n");
    printf(1, "- Parent PID: %d\n", getpid());
    printf(1, "- Children PIDs: %d (running), %d (sleeping), %d (zombie)\n\n",
          pids[0], pids[1], pids[2]);

    printf(1, "Expected Ctrl+I output should show:\n");
    printf(1, "1. Init process (PID 1) with 3 pages\n");
    printf(1, "2. Parent process (PID %d) with pages >3\n", getpid());
    printf(1, "3. Running child (PID %d) with pages >3\n", pids[0]);
    printf(1, "4. Sleeping child (PID %d) with pages >3\n\n", pids[1]);
    printf(1, "Zombie process (PID %d) should NOT appear\n\n", pids[2]);

    printf(1, "Press Ctrl+I now to verify...\n");

    // Keep parent process alive
    while(1) {
        sleep(1000);
    }

    exit();
}