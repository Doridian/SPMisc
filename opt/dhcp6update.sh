#!/tmp/busybox/sh

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

if xtables-multi ip6tables-save | grep -qF "commentipv6route"; then
	echo 'IPv6 /60 FWL ok'
else
	ip6tables -t mangle -A PRE_LAN_SUBNET -s "$FULLLANPREFIX" -i br0 -j ACCEPT --comment commentipv6route
	ip6tables -t mangle -I ROUTE_CTL_LIST -d "$FULLLANPREFIX" -j RETURN --comment commentipv6route
	ip6tables -F FORWARD_PREFIX
	ip6tables -A FORWARD_PREFIX ! -s "$FULLPREFIX" -i br0 -j REJECT --reject-with icmp6-dst-unreachable --comment commentipv6route
fi

if xtables-multi ip6tables-save | grep -qF "commentipv6dmz"; then
	echo 'IPv6 DMZ ok'
else
	ip6tables -D FORWARD_FIREWALL ! -i br+ -j DROP
	ip6tables -A FORWARD_FIREWALL -i gre+ -o br0 -j ACCEPT --comment commentipv6dmz
	ip6tables -A FORWARD_FIREWALL -i ppp256 -o br0 -j ACCEPT --comment commentipv6dmz
	ip6tables -A FORWARD_FIREWALL ! -i br+ -j DROP --comment commentipv6dmz
fi

if xtables-multi iptables-save | grep -qF "commentipv4dmz"; then
	echo 'IPv4 DMZ ok'
else
	iptables -t nat -A PREROUTING -i gre+ -j DNAT --to-destination 192.168.2.2 --comment commentipv4dmz
	iptables -t nat -A PREROUTING -i ppp256 -j DNAT --to-destination 192.168.2.2 --comment commentipv4dmz
	iptables -A FWD_SERVICE -d 192.168.2.2 -i gre+ -j ACCEPT --comment commentipv4dmz
	iptables -A FWD_SERVICE -d 192.168.2.2 -i ppp256 -j ACCEPT --comment commentipv4dmz
fi

sed "s~pd-pool .*~pd-pool $FULLLANPREFIX~" -i /tmp/opt/usr/etc/dibbler/server.conf
/tmp/opt/usr/sbin/dibbler-server stop
/tmp/opt/usr/sbin/dibbler-server start

