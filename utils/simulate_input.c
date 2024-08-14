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
	SUCCESS		= 0,
	INPUT_ERR	= -1,
	PIPE_ERR	= -2,
	FORK_ERR	= -3,
	IOCTL_ERR	= -4,
	EXEC_ERR	= -5
};

static int	parent(int pipe_fds[]);
static void	child(char *argv[], int pipe_fds[]);
static void	adjust_argv(char *argv[]);

int	main(int argc, char *argv[])
{
	int		pipe_fds[2];
	pid_t	pid;
	int		exit_code;

	if (argc < 2)
		return (INPUT_ERR);
	if (pipe(pipe_fds) == -1)
		return (PIPE_ERR);
	pid = fork();
	if (pid == -1)
		return (FORK_ERR);
	else if (pid == 0)
		child(argv, pipe_fds);
	else
		exit_code = parent(pipe_fds);
	return (exit_code);
}

static int	parent(int pipe_fds[])
{
	char	buffer[1024];
	ssize_t	bytes_read;
	bool	error;
	int		status;

	close(pipe_fds[0]);
	error = false;
	while (!error && (bytes_read = read(STDIN_FILENO, buffer, sizeof(buffer))) > 0)
	{
		for (size_t i = 0; !error && i < bytes_read; i++)
		{
			if (ioctl(pipe_fds[1], TIOCSTI, &buffer[i]) == -1)
			{
				printf("fail\n");
				error = true;
			}
		}
	}
	if (!error)
		ioctl(pipe_fds[1], TIOCSTI, "\n");
	close(pipe_fds[1]);
	wait(&status);
	return (WIFEXITED(status) ? WEXITSTATUS(status) : WTERMSIG(status) + 128);
}

static void	child(char *argv[], int pipe_fds[])
{
	close(pipe_fds[1]);
	dup2(pipe_fds[0], STDIN_FILENO);
	close(pipe_fds[0]);
	adjust_argv(argv);
	execvp(argv[0], &argv[1]);
	exit(EXEC_ERR);
}

static void	adjust_argv(char *argv[])
{
	argv[0] = argv[1];
	argv[1] = basename(argv[1]);
}
