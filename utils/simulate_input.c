#define _XOPEN_SOURCE 600
#define _GNU_SOURCE

#include <libgen.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <termios.h>

int main(int argc, char *argv[]) {
    int master, slave;
    pid_t pid;
    char *slave_name;

    if (argc < 3)
        return 1;

    // Open pseudo-terminal
    master = posix_openpt(O_RDWR | O_NOCTTY);
    if (master == -1) {
        perror("posix_openpt");
        return 1;
    }

    if (grantpt(master) == -1) {
        perror("grantpt");
        return 1;
    }

    if (unlockpt(master) == -1) {
        perror("unlockpt");
        return 1;
    }

    slave_name = ptsname(master);
    if (slave_name == NULL) {
        perror("ptsname");
        return 1;
    }

    pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }
	// Open the slave side of the PTY
	slave = open(slave_name, O_RDWR);
	if (slave == -1) {
		perror("open slave");
		exit(1);
	}

    if (pid == 0) {  // Child process
        close(master);


        // Create a new session and set the slave PTY as the controlling terminal
        if (setsid() == -1) {
            perror("setsid");
            exit(1);
        }

        if (ioctl(slave, TIOCSCTTY, 0) == -1) {
            perror("ioctl TIOCSCTTY");
            exit(1);
        }

        // Redirect stdin, stdout, and stderr to the slave PTY
        dup2(slave, STDIN_FILENO);
        dup2(slave, STDOUT_FILENO);
        dup2(slave, STDERR_FILENO);

        close(slave);

        execvp(argv[1], (char *[]){basename(argv[1]), NULL});
        perror("execvp");
        exit(2);
    }

    // Parent process
    close(slave);

    // Write input to the master side of the PTY
    write(master, argv[2], strlen(argv[2]));
    write(master, "\n", 1);

    // Close the master side to signal EOF to the child
    close(master);

    // Wait for the child to finish
    wait(NULL);

    return 0;
}
