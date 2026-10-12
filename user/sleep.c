#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
	// Check if exactly one argument is provided
	if (argc != 2) {
		fprintf(2, "sleep <ticks>\n");
		exit(1);
	}

	// Verify all characters are digits and check for negative sign or letters
	for (int i = 0; argv[1][i] != '\0'; i++) {
		if (argv[1][i] < '0' || argv[1][i] > '9') {
			fprintf(2, "sleep <ticks>\n");
			exit(1);
		}
	}

	int ticks = atoi(argv[1]);
	pause(ticks);
	exit(0);
}
