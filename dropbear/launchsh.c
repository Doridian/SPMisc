#include <stdlib.h>

// /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin/mips-unknown-linux-uclibc-gcc launchsh.c -o launchsh

int main(int argc, char *argv[]){
	putenv("PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin");
	putenv("LD_LIBRARY_PATH=/usr/local/lib:/lib:/usr/lib");
	argv[0] = "sh";
	execv("/usr/local/bin/sh", argv);
	return 1; // Never reached
}

