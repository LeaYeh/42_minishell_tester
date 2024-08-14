#include <libgen.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

enum exit_codes
{
	SUCCESS = 0,
	INPUT_ERR,
	PIPE_ERR,
	FORK_ERR,
	IOCTL_ERR,
	EXEC_ERR
};

static int	parent(char *argv[], int pipe_fds[]);
static void	child(char *argv[], int pipe_fds[]);

int	main(int argc, char *argv[])
{
	int		pipe_fds[2];
	pid_t	pid;

	if (argc < 3)
		return (INPUT_ERR);
	if (pipe(pipe_fds) == -1)
		return (PIPE_ERR);
	pid = fork();
	if (pid == -1)
		return (FORK_ERR);
	else if (pid == 0)
		child(argv, pipe_fds);
	else
		return (parent(argv, pipe_fds));
}

static int	parent(char *argv[], int pipe_fds[])
{
	bool	error = false;

	close(pipe_fds[0]);
	for (size_t i = 0; argv[2][i]; i++)
	{
		if (ioctl(STDIN_FILENO, TIOCSTI, &argv[2][i]) == -1)
		{
			error = true;
			break ;
		}
	}
	if (!error)
		if (ioctl(STDIN_FILENO, TIOCSTI, "\n") == -1)
			error = true;
	close(pipe_fds[1]);
	wait(NULL);
	return (error ? IOCTL_ERR : SUCCESS);
}

static void	child(char *argv[], int pipe_fds[])
{
	close(pipe_fds[1]);
	dup2(pipe_fds[0], STDIN_FILENO);
	close(pipe_fds[0]);
	execvp(argv[1], (char *[]){basename(argv[1]), NULL});
	exit(EXEC_ERR);
}
