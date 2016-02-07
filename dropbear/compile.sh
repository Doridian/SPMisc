./configure "--with-zlib=$TOOLCHAIN" "--prefix=/usr/local" --disable-syslog --disable-wtmp --disable-wtmpx --disable-lastlog --enable-bundled-libtom
make
"$TOOLCHAIN/bin/mips-unknown-linux-uclibc-gcc" launchsh.c -o launchsh
