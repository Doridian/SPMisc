#!/bin/sh
./configure "--prefix=/tmp/opt/snmp" --host=mips-unknown-linux-uclibc --without-perl-modules --disable-embedded-perl --with-default-snmp-version=1 --with-sys-contact=SpeedPort --with-sys-location=Unknown --with-logfile=none --with-persistent-directory=/tmp/opt/snmp/data
make
