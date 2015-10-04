#!/usr/bin/env bash

set -eu -o pipefail

function all_mount_points() { mount | sed 's/^.* on //' | sed 's/ type .*$//' ; }

function is_mount_point() {
    local path="${1}"
    local fullpath=$( cd "${path}" && pwd )
    all_mount_points | grep --quiet "^${fullpath}$"
}

cd "${1}"

cp /etc/resolv.conf etc/

if ! is_mount_point proc ; then mount -t proc none proc ; fi
if ! is_mount_point sys ; then mount -t sysfs /sys sys ; fi
if ! is_mount_point dev ; then mount -o bind /dev dev ; fi

mkdir -p lib/modules
if ! is_mount_point lib/modules ; then mount -o bind,readonly /lib/modules lib/modules ; fi

chroot . /bin/bash || true

umount lib/modules
umount dev
umount sys
umount proc

cd - >/dev/null
