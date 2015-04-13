#!/bin/sh
while true; do
	"$@"
	[ -e stop ] && exit
done
