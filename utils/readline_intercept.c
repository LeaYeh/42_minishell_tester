#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <readline/readline.h>

#ifdef INTERCEPT_DEBUG
# include <stdio.h>
#endif

#define EXIT_ENV_VAR "READLINE_INTERCEPT_EXIT"

// Function pointer type for the original readline
typedef char *(*t_rl_func)(const char *);

static char *read_line_no_echo(t_rl_func og_readline, const char *prompt);

char *readline(const char *prompt)
{
	static t_rl_func original_readline = NULL;
	static int       is_exit = -1;
	int              og_errno = errno;
	char            *result;

#ifdef INTERCEPT_DEBUG
	dprintf(STDERR_FILENO, "Intercepted readline call with prompt: %s\n", prompt);
#endif

	if (!original_readline)
	{
		original_readline = dlsym(RTLD_NEXT, "readline");
		if (!original_readline)
		{
#ifdef INTERCEPT_DEBUG
			dprintf(STDERR_FILENO, "%s\n", dlerror());
#endif
			errno = ENOSYS;
			return NULL;
		}
	}

	result = read_line_no_echo(original_readline, prompt);
	if (errno == ENOTTY)
	{
		errno = og_errno;
	}

	if (is_exit == -1)
	{
		is_exit = (getenv(EXIT_ENV_VAR) != NULL);
	}
	if (is_exit)
	{
		exit(0);
	}
	return result;
}

static char *read_line_no_echo(t_rl_func og_readline, const char *prompt)
{
	char   *line = NULL;
	size_t  len = 0;
	ssize_t read;

	if (isatty(STDIN_FILENO))
	{
		line = og_readline(prompt);
	}
	else
	{
		read = getline(&line, &len, stdin);
		if (read == -1)
		{
			free(line);
			line = NULL;
		}
		else
		{
			if (line[read - 1] == '\n')
			{
				line[read - 1] = '\0';
			}
		}
	}
	return line;
}
