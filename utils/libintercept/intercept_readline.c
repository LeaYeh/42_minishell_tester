#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <readline/readline.h>
#include "intercept.h"

// Function pointer type for the original function
typedef char *(*t_rl_func)(const char *);

static char *read_line_tty_prompt(t_rl_func orig_readline, const char *prompt);

char *readline(const char *prompt)
{
	static t_rl_func orig_readline = NULL;
	int              orig_errno = errno;
	char            *result;

	if (IS_FLAG_SET(FLAG_DEBUG)) {
		dprintf(STDERR_FILENO, "Intercepted readline call\n");
	}
	if (!orig_readline && !(orig_readline = get_orig_func("readline"))) {
		return NULL;
	}

	result = read_line_tty_prompt(orig_readline, prompt);
	if (errno == ENOTTY) {
		errno = orig_errno;
	}
	if (IS_FLAG_SET(FLAG_EXIT)) {
		exit(0);
	}
	return result;
}

// Prints prompt only if input is from a terminal
static char *read_line_tty_prompt(t_rl_func orig_readline, const char *prompt)
{
	char   *line = NULL;
	size_t  len = 0;
	ssize_t read;

	if (isatty(STDIN_FILENO)) {
		line = orig_readline(prompt);
	}
	else {
		if (IS_FLAG_SET(FLAG_DEBUG)) {
			dprintf(STDERR_FILENO, "Calling getline instead\n");
		}
		read = getline(&line, &len, stdin);
		if (read == -1) {
			free(line);
			line = NULL;
		}
		else {
			if (line[read - 1] == '\n') {
				line[read - 1] = '\0';
			}
		}
	}
	return line;
}
