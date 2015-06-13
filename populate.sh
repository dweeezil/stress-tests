#!/bin/bash

DIR=$(pwd)
cd /tank/fish || exit
mkdir -p {0..9}/{0..9}/{0..9} || exit
set $(echo [0-9]/[0-9]/[0-9])
cd $DIR
X=0
while true; do
	dirs=""
	for i in {1..30}; do
		if [ "$dirs" ]; then
			dirs="$dirs $1"
		else
			dirs="$1"
		fi
		shift
	done
	[ "$dirs" ] || exit

	for dir in $dirs; do
		./populate /tank/fish/$dir 0 5001 &
	done
	echo create: $X
	wait
	[ -e stop ] && exit
	X=$(( $X + 1 ))
done
