./configure "--with-zlib=$TOOLCHAIN" "--prefix=/tmp/dropbear/usr" --disable-wtmp --disable-wtmpx --disable-lastlog
make
"$TOOLCHAIN/bin/mips-unknown-linux-uclibc-gcc" launchsh.c -o launchsh
