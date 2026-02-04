#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

volatile sig_atomic_t got_sigterm = 0;
volatile sig_atomic_t got_sigint = 0;

void handle_sigterm(int sig) {
    (void)sig;
    got_sigterm = 1;
}

void handle_sigint(int sig) {
    (void)sig;
    got_sigint = 1;
}

int main() {
    printf("Parent running. PID: %d\n", getpid());

    struct sigaction sa1, sa2;
    sa1.sa_handler = handle_sigterm;
    sigemptyset(&sa1.sa_mask);
    sa1.sa_flags = 0;

    sa2.sa_handler = handle_sigint;
    sigemptyset(&sa2.sa_mask);
    sa2.sa_flags = 0;

    sigaction(SIGTERM, &sa1, NULL);
    sigaction(SIGINT, &sa2, NULL);

    pid_t child1 = fork();
    if (child1 == 0) {
        sleep(5);
        kill(getppid(), SIGTERM);
        exit(0);
    }

    pid_t child2 = fork();
    if (child2 == 0) {
        sleep(10);
        kill(getppid(), SIGINT);
        exit(0);
    }

    while (1) {
        if (got_sigterm) {
            printf("Parent received SIGTERM. Exiting gracefully.\n");
            break;
        }
        if (got_sigint) {
            printf("Parent received SIGINT. Exiting gracefully.\n");
            break;
        }
        sleep(1);
    }

    // Clean children
    while (wait(NULL) > 0) {}

    return 0;
}
