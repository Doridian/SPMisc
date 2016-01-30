#include <unistd.h>

int main() {
	putenv("PATH=/tmp/busybox:/usr/bin:/bin");
	execl("/tmp/busybox/sh", "/tmp/busybox/sh", NULL);
}

