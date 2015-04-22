#!/bin/bash

FS=tank/fish

while true; do
	for i in {1..10}; do
		zfs snapshot -r ${FS}@stress-$RANDOM &
	done
	wait
	[ -f stop ] && exit
done
