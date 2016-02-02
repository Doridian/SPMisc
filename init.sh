# sh /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/init.sh

mkdir -p /tmp/usbmount
mount -o exec /dev/sda1 /tmp/usbmount

rm -f /tmp/busybox /tmp/dropbear /tmp/opt
/tmp/usbmount/user/dfoxadm/busybox/ln -s /tmp/usbmount/user/dfoxadm/busybox /tmp
/tmp/busybox/ln -s /tmp/usbmount/user/dfoxadm/dropbear /tmp
/tmp/busybox/ln -s /tmp/usbmount/user/dfoxadm/opt /tmp

mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

LD_LIBRARY_PATH="/tmp/opt/snmp/lib:/lib:/usr/lib" /tmp/opt/snmp/sbin/snmpd -c /tmp/opt/snmp/snmpd.conf 2>/dev/null
/tmp/dropbear/usr/sbin/dropbear -R -E -p 192.168.2.1:22 2>/dev/null
