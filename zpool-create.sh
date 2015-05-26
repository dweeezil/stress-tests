#!/bin/sh

#
# zpool-create.sh - Wrapper around "zpool create" which enables a subset
# of pool features.
#

FEATURES=""

addfeature() {
	FEATURES="$FEATURES -o $1=enabled"
}

addfeature feature@async_destroy
addfeature feature@empty_bpobj
addfeature feature@lz4_compress
addfeature feature@spacemap_histogram
addfeature feature@enabled_txg
addfeature feature@hole_birth
addfeature feature@extensible_dataset
addfeature feature@embedded_data
addfeature feature@bookmarks
addfeature feature@filesystem_limits
# addfeature feature@large_blocks

zpool create -d $FEATURES "$@"
