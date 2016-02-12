#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin/mips-unknown-linux-uclibc-gcc dslinfo.c -o dslinfo
int main() {
	const char* queryString = getenv("QUERY_STRING");
	const int queryStringLen = strlen(queryString);
	char dslparam[128];

	printf("Content-Type: text/plain\n\n");

	if (queryStringLen < 1 || queryStringLen > 64) {
		printf("Please specify what you want...\n");
		return 0;
	}

	if (strcmp(queryString, "reset") == 0) {
		printf("Sorry, no resetting\n");
		return 0;
	}

	const char* queryStringCur = queryString;
	do {
		if(
			(*queryStringCur < 'a' || *queryStringCur > 'z') &&
			(*queryStringCur < 'A' || *queryStringCur > 'Z') &&
			(*queryStringCur < '0' || *queryStringCur > '9')
		) {
			printf("Please keep to alphanumeric requests...\n");
			return 0;
		}
		
	} while(*(++queryStringCur));

	snprintf(dslparam, 127, "--%s", queryString);

	fflush(stdout);
	execl("/bin/xdslcmd", "/bin/xdslcmd", "info", dslparam, NULL);
	return 1;
}

