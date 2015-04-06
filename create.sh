#!/bin/bash

# Set ONLY_CREATE for seeding the filesystem
: ${ONLY_CREATE:=0}

# Set ONLY_OVERWRITE to never create new files but to only overwrite existing once
: ${ONLY_OVERWRITE:=0}

# Probability of overwriting an existing file
: ${RAND_OVERWRITE:=20}

cd /tank/fish || exit

# Other interesting possible commands.
#mkdir -p {0..9}
#chmod g+s {0..9}
#setfacl -m d:g:test:rwX -m g:test:rwX {0..9}
#setfattr -n user.$file -v file $file

mkdir -p {0..9}/{0..9}/{0..9} || exit

work() {
	(
	cd $1
	for file in {0..1000}; do
		# Randomly overwrite
		[ "$RAND_OVERWRITE" -a -f "$file" ] &&
	 		[ $(( $RANDOM % 100 )) -le $RAND_OVERWRITE ] && echo $file > $file && continue

		# Force-create
		[ "$ONLY_CREATE" ] && echo $file > $file && continue

		# Force-overwrite
		[ "$ONLY_OVERWRITE" -a -f "$file" ] && echo $file > $file && continue

		# Create if non-existent
		[ -f "$file" ] || echo $file > $file
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
