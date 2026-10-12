#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

char words[MAXARG][512];

int main(int argc, char *argv[]) {
	char buf[512];
	char *args[MAXARG];
	int i, start, base, count, limit, status, pid, failed;
	int len, inword;
	char c;

	start = 1;
	limit = 0;

	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		if (argc < 4) {
			fprintf(2, "usage: xargs [-n N] cmd [args...]\n");
			exit(1);
		}

		limit = atoi(argv[2]);
		if (limit < 1) {
			fprintf(2, "usage: xargs [-n N] cmd [args...]\n");
			exit(1);
		}

		start = 3;
	}

	if (start >= argc) exit(1);

	base = 0;
	for (i = start; i < argc; i++) {
		if (base >= MAXARG - 1) exit(1);
		args[base++] = argv[i];
	}

	if (limit == 0)	limit = MAXARG - 1 - base;
	if (limit > MAXARG - 1 - base) limit = MAXARG - 1 - base;
	if (limit < 1) exit(1);

	count = 0;
	len = 0;
	inword = 0;
	failed = 0;

	while (read(0, &c, 1) == 1) {
		if (c == ' ' || c == '\t' || c == '\n') {
			if (inword) {
				buf[len] = '\0';
				strcpy(words[count], buf);
				args[base + count] = words[count];
				count++;
				len = 0;
				inword = 0;
				
				if (count == limit) {
					args[base + count] = 0;
					pid = fork();
					if (pid == 0) {
						exec(args[0], args);
						exit(1);
					}
					if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
					count = 0;
				}
			}

			if (c == '\n' && count > 0 && limit == MAXARG - 1 - base) {
				args[base + count] = 0;
				pid = fork();
				if (pid == 0) {
					exec(args[0], args);
					exit(1);
				}
				if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
				count = 0;
			}
		} else {
			if (len < sizeof(buf) - 1) {
				buf[len++] = c;
				inword = 1;
			} else {
				fprintf(2, "xargs: word too long\n");
				exit(1);
			}
		}
	}

	if (inword) {
		buf[len] = '\0';
		strcpy(words[count], buf);
		args[base + count] = words[count];
		count++;
	}
		
	if (count > 0) {
		args[base + count] = 0;
		pid = fork();
		if (pid == 0) {
			exec(args[0], args);
			exit(1);
		}
		if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
	}
	exit(failed);
}
