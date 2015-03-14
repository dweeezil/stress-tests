#!/bin/bash

#ONLY_OVERWRITE=1
RAND_OVERWRITE=20

cd /tank/fish
#cd /tmp/junk
#cd /junk

#mkdir -p {0..9}
#chmod g+s {0..9}
#setfacl -m d:g:test:rwX -m g:test:rwX {0..9}
#setfattr -n user.$file -v file $file

mkdir -p {0..9}/{0..9}/{0..9}

work() {
	(
	cd $1
	for file in {0..1000}; do
		if [ -f "$file" ]; then
			[ $(( $RANDOM % 100 )) -le $RAND_OVERWRITE ] && echo $file > $file
			continue
		fi
		[ "$ONLY_OVERWRITE" ] || echo $file > $file
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
	echo create: $X
	wait
	X=$(( $X + 1 ))
done
