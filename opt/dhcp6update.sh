#!/usr/local/bin/sh

TLANPREFIX="$(grep 'prefix' /var/radvd/radvdbr0.conf | sed 's/ *prefix *//' | tr -d ' \r\n' | sed 's/:0*/:/g')"
FULLPREFIX="$(echo "$TLANPREFIX" | sed -r 's~\w\w:\w+:\w+:\w+:\w+/64~~')"
TLANPREFIX="$(echo "$TLANPREFIX" | sed -r 's~\w+:\w+:\w+:\w+/64~:/64~')"

# Use only a part of the full /56 to make sure dibbler cannot delegate the prefix the router wishes to use

TLANPREFIX_FIRST="$(echo "$TLANPREFIX" | sed -r 's~.*(\w)::/64~\1~')"
if [ "$TLANPREFIX_FIRST" == "4" ]; then
	FULLLANPREFIX="${FULLPREFIX}50::/60"
else
	FULLLANPREFIX="${FULLPREFIX}40::/60"
fi

FULLPREFIX="${FULLPREFIX}00::/56"

if xtables-multi ip6tables-save | grep -qF "$FULLPREFIX"; then
	echo 'IPv6 /56 FWL ok'
else
	if [ -f /var/undo_ipv6_fwl.sh ]; then
		source /var/undo_ipv6_fwl.sh
	fi
	echo > /var/undo_ipv6_fwl.sh
	chmod -x /var/undo_ipv6_fwl.sh
	ip6tables -t mangle -A PRE_LAN_SUBNET -s $FULLLANPREFIX -i br0 -j ACCEPT
	ip6tables -t mangle -I ROUTE_CTL_LIST -d $FULLLANPREFIX -j RETURN
	ip6tables -F FORWARD_PREFIX
	ip6tables -A FORWARD_PREFIX ! -s $FULLPREFIX -i br0 -j REJECT --reject-with icmp6-dst-unreachable

	ip6tables -D FORWARD_FIREWALL ! -i br+ -j DROP
	ip6tables -A FORWARD_FIREWALL -d $FULLLANPREFIX -i gre+ -o br0 -j ACCEPT
	ip6tables -A FORWARD_FIREWALL -d $FULLLANPREFIX -i ppp256 -o br0 -j ACCEPT
	ip6tables -A FORWARD_FIREWALL ! -i br+ -j DROP

	echo "ip6tables -t mangle -D PRE_LAN_SUBNET -s $FULLLANPREFIX -i br0 -j ACCEPT" >> /var/undo_ipv6_fwl.sh
	echo "ip6tables -t mangle -D ROUTE_CTL_LIST -d $FULLLANPREFIX -j RETURN" >> /var/undo_ipv6_fwl.sh
	echo "ip6tables -D FORWARD_FIREWALL -d $FULLLANPREFIX -i gre+ -o br0 -j ACCEPT" >> /var/undo_ipv6_fwl.sh
	echo "ip6tables -D FORWARD_FIREWALL -d $FULLLANPREFIX -i ppp256 -o br0 -j ACCEPT" >> /var/undo_ipv6_fwl.sh
	echo 'IPv6 /56 FWL fixed'
fi

if ip -6 route | grep -qF "$FULLLANPREFIX"; then
	echo "IPv6 $FULLLANPREFIX route ok"
else
	if [ -f /var/undo_ipv6_route.sh ]; then
		source /var/undo_ipv6_route.sh
	fi
	echo > /var/undo_ipv6_route.sh
	chmod -x /var/undo_ipv6_route.sh
	/bin/ip -6 route add $FULLLANPREFIX dev br0 metric 256
	/bin/ip -6 route add $FULLLANPREFIX dev br0 metric 256 table 200
	/bin/ip -6 route add $FULLLANPREFIX dev br0 metric 256 table 201
	echo "/bin/ip -6 route del $FULLLANPREFIX dev br0 metric 256" >> /var/undo_ipv6_route.sh
	echo "/bin/ip -6 route del $FULLLANPREFIX dev br0 metric 256 table 200" >> /var/undo_ipv6_route.sh
	echo "/bin/ip -6 route del $FULLLANPREFIX dev br0 metric 256 table 201" >> /var/undo_ipv6_route.sh
	echo "IPv6 $FULLLANPREFIX route fixed"
fi

OLDMD5SUM="$(md5sum /usr/local/etc/dibbler/server.conf)"
sed "s~pd-pool .*~pd-pool $FULLLANPREFIX~" -i /usr/local/etc/dibbler/server.conf
NEWMD5SUM="$(md5sum /usr/local/etc/dibbler/server.conf)"
if [ "$OLDMD5SUM" != "$NEWMD5SUM" ]; then
	echo "Restarting DHCPv6"
	/usr/local/sbin/dibbler-server stop
else
	echo "DHCPv6 is OK"
fi
/usr/local/sbin/dibbler-server status || /usr/local/sbin/dibbler-server start

