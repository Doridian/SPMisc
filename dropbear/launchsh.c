#include <stdlib.h>

// /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin/mips-unknown-linux-uclibc-gcc launchsh.c -o launchsh

int main(int argc, char *argv[]){
	putenv("PATH=/tmp/busybox:/tmp/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin");
	putenv("LD_LIBRARY_PATH=/tmp/opt/lib:/tmp/opt/usr/lib:/lib:/usr/lib");
	argv[0] = "sh";
	execv("/tmp/busybox/sh", argv);
	return 1; // Never reached
}

