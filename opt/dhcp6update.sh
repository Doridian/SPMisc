#!/tmp/busybox/sh

TLANPREFIX="$(grep 'prefix' /var/radvd/radvdbr0.conf | sed 's/ *prefix *//' | tr -d ' \r\n' | sed 's/:0*/:/g')"
FULLPREFIX="$(echo "$TLANPREFIX" | sed -r 's~\w\w:\w+:\w+:\w+:\w+/64~~')"
TLANPREFIX="$(echo "$TLANPREFIX" | sed -r 's~\w+:\w+:\w+:\w+/64~:/64~')"

# Use only a part of the full /56 to make sure dibbler cannot delegate the prefix the router wishes to use

TLANPREFIX_FIRST="$(echo "$TLANPREFIX" | sed -r 's~.*(\w)::/64~\1~')"
if [ "$TLANPREFIX_FIRST" == "4" ]; then
	FULLLANPREFIX="${FULLPREFIX}50::/60"
else
	FULLLANPREFIX="${FULLPREFIX}40::/64"
fi

FULLPREFIX="${FULLPREFIX}00::/56"

if xtables-multi ip6tables-save | grep -qF "$TLANPREFIX"; then
	xtables-multi ip6tables-save | grep -vF "/56" | sed "s~$TLANPREFIX~$FULLPREFIX~g" | xtables-multi ip6tables-restore
fi

sed "s~pd-pool .*~pd-pool $FULLLANPREFIX~" -i /tmp/opt/usr/etc/dibbler/server.conf
/tmp/opt/usr/sbin/dibbler-server stop
/tmp/opt/usr/sbin/dibbler-server start

