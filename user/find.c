#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

// Wildcard matcher
int match(char *pattern, char *string) {
	if (pattern[0] == '\0') return string[0] == '\0';
	if (pattern[0] == '*') {
		for (int i = 0; string[i] != '\0'; i++) {
			if (match(pattern + 1, string + i)) return 1;
		}
		return match(pattern + 1, string);
	}
	if (string[0] != '\0' && (pattern[0] == string[0])) {
		return match(pattern + 1, string + 1);
	}
	return 0;
}

// Recursive find function
int find(char *path, char *pattern, char *type) {
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;

	if ((fd = open(path, 0)) < 0) {
		fprintf(2, "find: cannot open %s\n", path);
		return -1;
	}

	if (fstat(fd, &st) < 0) {
		close(fd);
		return -1;
	}

	if (st.type != T_DIR) {
		close(fd);
		return -1;
	}

	if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
		close(fd);
		return -1;
	}

	strcpy(buf, path);
	p = buf + strlen(buf);
	*p++ = '/';

	while (read(fd, &de, sizeof(de)) == sizeof(de)) {
		if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) continue;

		memmove(p, de.name, DIRSIZ);
		p[DIRSIZ] = '\0';

		if (stat(buf, &st) < 0) continue;

		if (match(pattern, de.name)) {
			if (type == 0 || (strcmp(type, "f") == 0 && (st.type == T_FILE || st.type == T_DEVICE)) || (strcmp(type, "d") == 0 && st.type == T_DIR)) {
				printf("%s\n", buf);
			}
		}

		if (st.type == T_DIR) find(buf, pattern, type);
	}
	close(fd);
	return 0;
}

int main(int argc, char *argv[]) {
	char *type = 0;

	if (argc != 3 && argc != 5) {
		fprintf(2, "usage: find <dir> <pattern> [-type f|d]\n");
		exit(1);
	}

	if (argc == 5) {
		if (strcmp(argv[3], "-type") != 0 || (strcmp(argv[4], "f") != 0 && strcmp(argv[4], "d") != 0)) {
			fprintf(2, "usage: find <dir> <pattern> [-type f|d]\n");
			exit(1);
		}
		type = argv[4];
	}

	if (find(argv[1], argv[2], type) < 0) exit(1);
	exit(0);
}
