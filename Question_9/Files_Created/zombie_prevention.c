#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    int i;
    int num_children = 5;

    printf("Parent PID: %d\n", getpid());

    for (i = 0; i < num_children; i++) {
        pid_t pid = fork();

        if (pid < 0) {
            perror("fork failed");
            exit(1);
        }

        if (pid == 0) {
            printf("Child %d started. PID: %d (Parent: %d)\n", i + 1, getpid(), getppid());
            sleep(1 + i);  
            printf("Child %d exiting. PID: %d\n", i + 1, getpid());
            exit(0);
        }
    }

    for (i = 0; i < num_children; i++) {
        int status;
        pid_t cleaned = wait(&status);
        if (cleaned > 0) {
            printf("Parent cleaned child PID: %d\n", cleaned);
        }
    }

    printf("All child processes cleaned. No zombies remain.\n");
    return 0;
}
