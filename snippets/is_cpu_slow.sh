#!/bin/bash

set -e
set -o pipefail
set -x

# functions:

function has_bogomips() { grep --quiet -i 'bogomips' /proc/cpuinfo ; }
function bogomips() { grep -i 'bogomips' /proc/cpuinfo | tr ':.' ' ' | awk '{print $2}' ; }

function has_mhz() { grep --quiet -i 'cpu mhz' /proc/cpuinfo ; }
function mhz() { grep -i 'cpu mhz' /proc/cpuinfo | tr ':.' ' ' | awk '{print $2}' ; }

function cpu_is_slow()
{
    if has_bogomips && [ "$(bogomips)" -lt 1000 ] ; then return 0 ; fi
    if has_mhz && [ "$(mhz)" -lt 500 ] ; then return 0 ; fi
    return 1
}



# main:

if cpu_is_slow
then
    echo "slow!"
else
    echo "not so slow"
fi
