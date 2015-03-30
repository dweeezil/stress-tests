#!/bin/bash

#
# test1.sh - Run a pair of both create.sh and remove-random.sh.
#
# Ideally, the testing filesystem (/tank/fish) should be pre-populated
# by running
#
#	ONLY_CREATE=1 ./create.sh 

echo -n Starting jobs....
./spin.sh ./create.sh > /dev/null 2>&1 &
./spin.sh ./remove-random.sh > /dev/null 2>&1 &
./spin.sh ./create.sh > /dev/null 2>&1 &
./spin.sh ./remove-random.sh > /dev/null 2>&1 &
echo

#
# Wait awhile for the ARC to fill.
#
echo -n Waiting 30 seconds for ARC fill...
sleep 30
echo

#
# Start the hog
#
X=0
echo "Hogging memory..."
while true; do
	echo "Hog: $X"
	echo -n "    "
	../junkutils/maxsbrk 10 2000
	X=$(( $X + 1 ))
	[ $(( $X % 5 )) -eq 0 ] && echo -n "Sleeping..." && sleep 20 && echo
done
