# source /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/mkdirs.sh
# cat /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/mkdirs.sh
ROOTDIR=/tmp/rootrw
/bin/mkdir -p $ROOTDIR
/bin/mount -t jffs2 /dev/mtdblock0 $ROOTDIR
/bin/mount -o remount,rw /dev/mtdblock0 $ROOTDIR
/bin/mkdir -p $ROOTDIR/home $ROOTDIR/opt $ROOTDIR/usr/local
/bin/umount $ROOTDIR
