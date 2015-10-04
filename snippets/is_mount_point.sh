#!/usr/bin/env bash

set -eu -o pipefail

function all_mount_points() { mount | sed 's/^.* on //' | sed 's/ type .*$//' ; }

function is_mount_point() {
    local path="${1}"
    local fullpath=$( cd "${path}" && pwd )
    all_mount_points | grep --quiet "^${fullpath}$"
}


# demo / tests:

# works with absolute paths:
if is_mount_point /proc ; then echo "/proc is a mount point" ; fi

# also works with relative paths:
cd /
if is_mount_point proc ; then echo "proc is a mount point" ; fi

# correctly reports "no" for subdirectories inside of a mount point:
if ! is_mount_point /proc/sys ; then echo "/proc/sys is not a mount point" ; fi
