#include <stdlib.h>

int main(int argc, char *argv[]){
	putenv("PATH=/tmp/busybox:/usr/bin:/bin");
	argv[0] = "sh";
	execv("/tmp/busybox/sh", argv);
	return 1; // Never reached
}

