#!/usr/bin/env bash

# strict mode
set -eu -o pipefail


# mount points

function all_mount_points()
{
    mount | sed 's/^.* on //' | sed 's/ type .*$//'
}

function is_mount_point()
{
    local path="${1}"
    local fullpath=$( cd "${path}" && pwd )
    all_mount_points | grep --quiet "^${fullpath}$"
}


# mounted devices

function all_mounted_devices()
{
    mount | awk '{ print $1 }' | grep '^/dev/' || true | sort | uniq
}

function is_mounted_device()
{
    local dev="${1}"
    all_mounted_devices | grep --quiet "^${dev}$"
}


# demo / tests:

# works with absolute paths:
if is_mount_point /proc
then
    echo "/proc is a mount point"
fi

# also works with relative paths:
cd /
if is_mount_point proc
then
    echo "proc is a mount point"
fi

# correctly reports "no" for subdirectories inside of a mount point:
if ! is_mount_point /proc/sys
then
     echo "/proc/sys is not a mount point"
fi

echo "All mounted devices:"
all_mounted_devices

for i in /dev/sda1 /dev/mmcblk0p1 /dev/sr0 /dev/cdrom
do
    if is_mounted_device $i
    then
        echo $i is a mounted device
    else
        echo $i is not mounted device
    fi
done

