# source /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/init.sh
# cat /mnt/Verbatim_STORE_N_GO-18A57149_usb1_1/init.sh

mount -o exec /dev/sda1 /opt

ifconfig br0:9 169.254.100.156 netmask 255.255.0.0

mount --bind /opt/usrlocal /usr/local
mount --bind /opt/home /home

mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

export LD_LIBRARY_PATH="/usr/local/lib:/lib:/usr/lib"
export PATH="/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

snmpd -c /usr/local/etc/snmpd.conf
dropbear -R -p 192.168.2.1:22
httpd -p 192.168.2.1:81 -h /usr/local/var/www -c /usr/local/etc/httpd.conf
crond -L /usr/local/var/log/cron.log -c /usr/local/var/lib/cron

nflx.sh
radvdfix.sh
#dhcp6update.sh
