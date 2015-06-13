#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

main(int argc, char **argv) {
	int i, j, fd;
	char buf[1024];
	char *dir;
	ssize_t written;

	if (argc != 4)
		exit(1);

	dir = argv[1];
	i = atoi(argv[2]);
	j = atoi(argv[3]);
	if (chdir(dir) < 0)
		exit(0);
	if (j <= i)
		exit(0);

	while (i < j) {
		snprintf(buf, sizeof buf, "%d", i);
		fd = open(buf, O_WRONLY | O_CREAT, 0644);
		if (fd < 0)
			exit(1);
		written = write(fd, buf, strlen(buf));
		close(fd);
		++i;
	}
}
