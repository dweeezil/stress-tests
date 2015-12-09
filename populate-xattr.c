#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <attr/xattr.h>

#define NAMELEN 20
#define ATTRNAME "user.fhgfs"
#define ATTRVAL "0sBAECAAMAAADGDgBSAAAAAFo9AFIAAAAAknkvUgAAAACSeS9SAAAAAGQFAADnAwAA/UEAAAIAAAANAAAAMTItNTFGQzVEM0QtMQAAAAwAAAA1LTUxRkM1RDNELTEAAAAAAQABABgAAAABAAAAAAAIAAQAAAAIAAAAAAAAAA=="

static char attrname[] = ATTRNAME;
static char attrval[] = ATTRVAL;

main(int ac, char **av) {
	char buf[512], filename[NAMELEN + 1];
	FILE *randstuff;
	int limit, fd, i, j, c;
	unsigned  numfiles;

	filename[NAMELEN] = '\0';
	if ((randstuff = fopen("/dev/urandom", "r")) == NULL) {
		fprintf(stderr, "can't open /dev/urandom\n");
		exit(1);
	}

	if (ac == 2)
		limit = atoi(av[1]);
	else
		limit = 100;

	/* read a list of directories from stdin
	 */
	while (fgets(buf, sizeof buf, stdin)) {
		buf[strlen(buf) - 1] = '\0';
		if (chdir(buf) == -1)
			continue;

		/* calculate the number of files to place in this directory
		 */
		if (fread(&numfiles, sizeof numfiles, 1, randstuff) == 1)
			numfiles %= limit;
		else
			continue;
		if (numfiles == 0)
			continue;
		printf("creating %d files in %s\n", numfiles, buf);

		for (i = 0 ; i < numfiles ; ++i) {
			/* create a random file name
			 */
			for (j = 0 ; j < NAMELEN ; ) {
				c = fgetc(randstuff);
				if (c < 33 || c > 126 || c == '/')
					continue;
				filename[j] = c;
				++j;
			}

			/* create the file and set the xattr
			 */
			if ((fd = creat(filename, 0664)) == -1) {
				printf("\"%s\": unable to create \"%s\"\n", buf, filename);
				continue;
			}
			fsetxattr(fd, attrname, attrval, sizeof(attrval) - 1, XATTR_CREATE);
			close(fd);
		}
	}
}
