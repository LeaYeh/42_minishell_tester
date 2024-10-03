#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define EXIT_ENV_VAR "READ_INTERCEPT_EXIT"

/* Function pointer type for the original read */
typedef ssize_t (*t_read_func)(int, void *, size_t);

ssize_t read(int fd, void *buf, size_t count)
{
	static t_read_func original_read = NULL;
	static int         is_exit = -1;
	ssize_t            result;

	if (!original_read)
	{
		original_read = dlsym(RTLD_NEXT, "read");
		if (!original_read)
		{
			dprintf(STDERR_FILENO, "%s\n", dlerror());
			errno = ENOSYS;
			return -1;
		}
	}

	// dprintf(STDERR_FILENO, "Intercepted read call with fd: %d\n", fd);
	result = original_read(fd, buf, count);
	// dprintf(STDERR_FILENO, "Read %ld bytes\n", result);

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
