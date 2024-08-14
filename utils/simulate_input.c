#include <libgen.h>
#include <stddef.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int	main(int argc, char *argv[])
{
	int		pipe_fds[2];
	pid_t	pid;

	if (argc < 3)
		return (1);

	pipe(pipe_fds);

	pid = fork();
	if (pid == 0)
	{
		close(pipe_fds[1]);
		dup2(pipe_fds[0], STDIN_FILENO);
		close(pipe_fds[0]);
		execvp(argv[1], (char *[]){basename(argv[1]), NULL});
		exit(2);
	}

	close(pipe_fds[0]);
	for (size_t i = 0; argv[2][i]; i++)
		ioctl(STDIN_FILENO, TIOCSTI, &argv[2][i]);
	ioctl(STDIN_FILENO, TIOCSTI, "\n");
	close(pipe_fds[1]);

	wait(NULL);

	return (0);
}
