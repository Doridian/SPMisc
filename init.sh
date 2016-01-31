# sh /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/init.sh

cd /

umount /dev/sda1
mount /dev/sda1 /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1 

rm -f /tmp/busybox /tmp/dropbear
/mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/busybox/ln -s /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/busybox /tmp
/tmp/busybox/ln -s /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/dropbear /tmp

mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

/tmp/dropbear/usr/sbin/dropbear -R -E 2>/dev/null
