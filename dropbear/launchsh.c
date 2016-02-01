#include <stdlib.h>

int main(int argc, char *argv[]){
	putenv("PATH=/tmp/busybox:/tmp/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin");
	putenv("LD_LIBRARY_PATH=/tmp/opt/lib:/lib:/usr/lib");
	argv[0] = "sh";
	execv("/tmp/busybox/sh", argv);
	return 1; // Never reached
}

