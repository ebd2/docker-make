#!/bin/sh

usage() {
	echo "$0 {target image}" >&2
}

#
# This doesn't handle ARGs with a default supplied in the Dockerfile.
# Feel free to add that functionality if needed. For now, YAGNI.
#
find_args() {
	local target_dockerfile="$1"
	local target_image="$2"

	awk -v image="$target_image" '
		$1 == "ARG" {
			key = $2;
			print "DBFLAGS_" image " += --build-arg " key "=$(" key ")";
		}' "$target_dockerfile"
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

target_dockerfile=$1
image_name=$2

find_args "$target_dockerfile"
