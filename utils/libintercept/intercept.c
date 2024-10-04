#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "intercept.h"

static t_flags init_flags(void);

void *get_orig_func(const char *name)
{
	void *orig_func;

	orig_func = dlsym(RTLD_NEXT, name);
	if (!orig_func) {
		if (IS_FLAG_SET(FLAG_DEBUG)) {
			dprintf(STDERR_FILENO, "%s\n", dlerror());
		}
		errno = ENOSYS;
	}
	return orig_func;
}

t_flags get_flags(void)
{
	static t_flags flags = NONE;
	static bool    initialized = false;

	if (!initialized) {
		flags = init_flags();
		initialized = true;
	}
	return flags;
}

static t_flags init_flags(void)
{
	t_flags flags = NONE;

	if (getenv(DEBUG_ENV_VAR)) {
		flags |= FLAG_DEBUG;
	}
	if (getenv(EXIT_ENV_VAR)) {
		flags |= FLAG_EXIT;
	}
	return flags;
}
