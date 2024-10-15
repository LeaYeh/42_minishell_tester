/*
* libintercept - Function Call Interceptor
*
* This library intercepts function calls using the LD_PRELOAD mechanism. It
* provides a way to modify or monitor behavior in other programs without
* modifying their source code.
*
* Features:
* - Provides debugging output based on environment variable
* - Can trigger program exit based on environment variable
*
* Usage:
* Compile as a shared library and use with LD_PRELOAD:
*   $ make [function_name]
*   $ LD_PRELOAD=./libintercept.so ./some_program
*
* Environment Variables:
* - INTERCEPT_DEBUG: Enable debug output
* - INTERCEPT_EXIT: If set, causes the program to exit after the intercepted call
*
* Limitations:
* - Can only intercept dynamically linked functions
*
* Author: itislu [https://github.com/itislu]
*/

#ifndef INTERCEPT_H
# define INTERCEPT_H

# define DEBUG_ENV_VAR "LIBINTERCEPT_DEBUG"
# define EXIT_ENV_VAR  "LIBINTERCEPT_EXIT"

typedef enum e_flags {
	NONE       = 0,
	FLAG_DEBUG = 1 << 0,
	FLAG_EXIT  = 1 << 1,
} t_flags;

# define IS_FLAG_SET(flag) ((get_flags() & (flag)) != NONE)

void   *get_orig_func(const char *name);
t_flags get_flags(void);

#endif
