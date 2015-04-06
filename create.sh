#!/bin/bash

# NOTE: Probabilities are percentage * 100

# Set ONLY_CREATE for seeding the filesystem
: ${ONLY_CREATE:=0}

# Set ONLY_OVERWRITE to never create new files but to only overwrite existing once
: ${ONLY_OVERWRITE:=0}

# Probability of overwriting an existing file - default 20%
: ${RAND_OVERWRITE:=200}

# Probability of overwriting/creating a large file - default 0.1%
: ${RAND_LARGEFILE:=1}

cd /tank/fish || exit

# Other interesting possible commands.
#mkdir -p {0..9}
#chmod g+s {0..9}
#setfacl -m d:g:test:rwX -m g:test:rwX {0..9}
#setfattr -n user.$file -v file $file

mkdir -p {0..9}/{0..9}/{0..9} || exit

prob() {
	[ $(( $RANDOM % 1000 )) -lt $1 ] && return 0
	return 1
}

dolargefile() {
	# Create a 1MiB random file
	dd if=/dev/urandom count=2048 of=$1 2> /dev/null
	echo LARGEFILE: $PWD/$1
}

doregularfile() {
	# Create a self-referential file
	echo $1 > $1
}

dofile() {
	# Create a self-referential file or a large file depending on the probability
	[ "${RAND_LARGEFILE}" ] && prob $RAND_LARGEFILE && dolargefile $1 && return 0
	doregularfile $1
	return 0
}

makefile() {
	# Randomly overwrite
	[ "$RAND_OVERWRITE" -a -f "$1" ] &&
		prob $RAND_OVERWRITE && dofile $1 && return

	# Force-create
	[ "$ONLY_CREATE" ] && dofile $1 && continue

	# Force-overwrite
	[ "$ONLY_OVERWRITE" -a -f $1 ] && dofile $1 && continue

	# Create if non-existent
	[ -f "$1" ] || dofile $1
} 

work() {
	(
	cd $1
	for file in {0..5000}; do
		makefile $file
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
