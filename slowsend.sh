#!/bin/sh

FS=tank/fish

for X in 0 1 2 3 4 5; do
	zfs snapshot ${FS}@$X
	( zfs send -Rp ${FS}@$X | ~tim/src/junkutils/slowread 10 &)
	echo slowsend: launched $X
	sleep 60
done
