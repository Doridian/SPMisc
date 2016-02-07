# source /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/user/dfoxadm/init.sh

mount -o exec /dev/sda1 /opt

killall dhcp6s

ip route add 169.254.0.0/16 dev br0
ip route del 169.0.0.0/8 dev br0

mount --bind /opt/usrlocal /usr/local
mount --bind /opt/home /home

mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

LD_LIBRARY_PATH="/usr/local/lib:/lib:/usr/lib" /usr/local/sbin/snmpd -c /usr/local/etc/snmp/snmpd.conf 2>/dev/null
/usr/local/sbin/dropbear -R -E -p 192.168.2.1:22 2>/dev/null
/usr/local/bin/httpd -p 192.168.2.1:81 -h /usr/local/var/www -c /usr/local/etc/httpd.conf 2>/dev/null
LD_LIBRARY_PATH="/usr/local/lib:/lib:/usr/lib" /usr/local/bin/dhcp6update.sh 2>/dev/null

