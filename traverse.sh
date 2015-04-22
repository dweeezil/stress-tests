#!/bin/bash

cd /tank/fish || exit

work() {
	(
	cd $1
	for file in {0..5000}; do
		md5sum $1 > /dev/null 2>&1
	done
	)
}

set $(echo [0-9]/[0-9]/[0-9])

X=0
while true; do
	dirs=""
	for i in {1..20}; do
		if [ "$dirs" ]; then
			dirs="$dirs $1"
		else
			dirs="$1"
		fi
		shift
	done
	[ "$dirs" ] || exit

	for dir in $dirs; do
		work $dir &
	done
	echo traverse: $X
	wait
	[ -e stop ] && exit
	X=$(( $X + 1 ))
done
