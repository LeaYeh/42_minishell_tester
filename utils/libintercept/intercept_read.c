#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "intercept.h"

// Function pointer type for the original function
typedef ssize_t (*t_read_func)(int, void *, size_t);

ssize_t read(int fd, void *buf, size_t count)
{
	static t_read_func orig_read = NULL;
	ssize_t            result;

	if (IS_FLAG_SET(FLAG_DEBUG)) {
		dprintf(STDERR_FILENO, "Intercepted read call\n");
	}
	if (!orig_read && !(orig_read = get_orig_func("read"))) {
		return -1;
	}

	result = orig_read(fd, buf, count);
	if (IS_FLAG_SET(FLAG_EXIT)) {
		exit(0);
	}
	return result;
}
