#include <stdlib.h>
#include <at_if.h>

// /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin/mips-unknown-linux-uclibc-gcc -I/opt/DT_Hybrid_GPL_1.00.053/DT-W724V-20140311/output/host/usr/mips-unknown-linux-uclibc/sysroot/usr/include -L/opt/DT_Hybrid_GPL_1.00.053/DT-W724V-20140311/output/host/usr/mips-unknown-linux-uclibc/sysroot/lib lteq.c -o lteq -lcfmapi -lvdb -lsqlite -lhttpapi -lmsgapi -lxmlapi -lbhalapi -lcrypto -lssl -lz -liconv -lpthread -lgplutil -latshared -ldl

/*typedef enum
{
    AT_CMD_RES_ERR = -3,//ERROR,ÎÞÀàÐÍµÄERROR
    AT_CMD_RES_SUCCESS = -2,  //ok
    AT_CMD_RES_BUSY = -1,  //ËùÓÐcme cms errorµÄŒ¯ºÏ,
    //Ç°ÈýžöÎªÂ·ÓÉÄ£¿é×Ô¶šÒå²¢Ê¹ÓÃµÄŽíÎóºÅ.
    AT_CMD_RES_SIM_NOT_INSERT =10,
    AT_CMD_RES_PIN_REQ= 11, //ÎÒÃÇ¹ØÐÄµÄPINŽíÎó.
    AT_CMD_RES_PUK_REQ = 12,
    AT_CMD_RES_SIM_FAIL = 13,
    AT_CMD_RES_SMS_FULL = 14,/* <DTS2013083001384 xiazhongyue 20130830 modify> *
    AT_CMD_RES_NO_NETWORK = 15,	 /* <DTS2013103107401  z00185914 2013/11/07 BEGIN *
    AT_CMD_RES_REJECT_NETWORK = 16,  /* DTS2013103107401   z00185914 2013/11/07 END> *
    AT_CMD_RES_AMSS_MAX = 65535//×îŽóÖµ.
}AT_AMSS_RES_EN;*/

int main() {
	LcellinfoResType res;
	VOS_INT32 ret;

	printf("Content-Type: application/json\n\n");

	ret = AT_Lcellinfo(AT_CMD_TYPE_CHECK, NULL, &res);
	if (!ret || res.AtExeResult != AT_CMD_RES_SUCCESS) {
		printf("{\"success\": true, \"rsrp\": %s, \"rsrq\": %s, \"rssi\": %s, \"freq\": %s, \"band\": %s, \"cellId\": %s}\n", res.Rsrp, res.Rsrq, res.Rssi, res.Freq, res.Band, res.CellId);
		return 0;
	} else {
		printf("{\"success\": false, \"return\": %d, \"atExeResult\": %d}\n", ret, res.AtExeResult);
		return 1;
	}
}
