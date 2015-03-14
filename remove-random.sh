#!/bin/bash

RMPCT=10

cd /tank/fish
#cd /tmp/junk
#cd /junk

work() {
	(
	cd $1

	find . -type f -print |
	while true; do
		files=""
		read file
		[ $(( $RANDOM % 100  )) -le $RMPCT ] || continue
		if [ "$files" ]; then
			files="$files $file"
		else
			files="$file"
		fi
		[ "$files" ] || return
		rm -f $files
	done
	)
}

set $(echo [0-9]/[0-9]/[0-9])

X=0
while true; do
	dirs=""
	for i in {1..10}; do
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
	echo remove-random: $X
	wait
	X=$(( $X + 1 ))
done
