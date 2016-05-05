#!/usr/local/bin/sh

RADCONF=/var/radvd/radvdbr0.conf
if grep -qF 'AdvOtherConfigFlag on' "$RADCONF"; then
	echo 'AdvOtherConfig OK'
else
	echo 'AdvOtherConfig FAIL'
	sed -ir 's/AdvOtherConfigFlag .*/AdvOtherConfigFlag on ;/' "$RADCONF"
	killall -HUP radvd
fi
