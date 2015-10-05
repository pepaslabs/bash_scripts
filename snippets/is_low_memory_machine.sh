#!/usr/bin/env bash

set -eu -o pipefail
set -x

function ram_in_kb() { cat /proc/meminfo | grep '^MemTotal:' | awk '{print $2}' ; }
function is_low_memory_machine() { [ "$(ram_in_kb)" -le "$(( 256 * 1024 ))" ] ; }

if is_low_memory_machine
then
    echo "this is a low memory machine"
else
    echo "this machine has a decent amount of ram"
fi
