#include <libgen.h>
#include <stddef.h>
#include <sys/ioctl.h>
#include <unistd.h>

int	main(int argc, char *argv[])
{
	if (argc < 3)
		return (1);
	for (size_t i = 0; argv[2][i]; i++)
		ioctl(STDIN_FILENO, TIOCSTI, &argv[2][i]);
	ioctl(STDIN_FILENO, TIOCSTI, "\n");
	close(STDIN_FILENO);
	execvp(argv[1], (char *[]){basename(argv[1]), NULL});
	return (2);
}
