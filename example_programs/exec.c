/* example using an argument vector */

#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

struct {
    char *fname;
    char *argv[5];
} cmd;

int
main(
    int argc,
    char *argv[])
{
    cmd.fname = "/usr/bin/head";  /* might need to be changed for your platform */
    cmd.argv[0] = "head";
    cmd.argv[1] = "-5";
    cmd.argv[2] = "/etc/passwd";
    cmd.argv[3] = NULL;   // VERY IMPORTANT

    if (fork() == 0) {
        /* child */
        execv(cmd.fname,cmd.argv);
        perror(cmd.fname);
        _exit(1);
    }
    wait(0);
}
