#!/bin/bash

# Chance of removing a file.
: ${RMPCT:=2}

cd /tank/fish || exit

work() {
	(
	cd $1

	files=""
	for file in *; do
		[ "$file" = "*" ] && break
		[ $(( $RANDOM % 100  )) -lt $RMPCT ] || continue
		files="$files $file"
	done
	[ "$files" ] && rm -f $files
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
