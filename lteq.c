#include <stdlib.h>
#include <at_if.h>

// /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin/mips-unknown-linux-uclibc-gcc -I/opt/DT_Hybrid_GPL_1.00.053/DT-W724V-20140311/output/host/usr/mips-unknown-linux-uclibc/sysroot/usr/include -L/opt/DT_Hybrid_GPL_1.00.053/DT-W724V-20140311/output/host/usr/mips-unknown-linux-uclibc/sysroot/lib lteq.c -o lteq -lcfmapi -lvdb -lsqlite -lhttpapi -lmsgapi -lxmlapi -lbhalapi -lcrypto -lssl -lcrypto -lz -liconv -lpthread -lgplutil -latshared -ldl

int main() {
	LcellinfoResType res;
	VOS_INT32 ret;

	ret = AT_Lcellinfo(AT_CMD_TYPE_CHECK, NULL, &res);
	if (!ret) {
		printf("OK,%s,%s,%s\n", res.Rsrp, res.Rsrq, res.Rssi);
		return 0;
	} else {
		printf("ERR,%d\n", ret);
		return 1;
	}
}
