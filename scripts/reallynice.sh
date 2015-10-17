#!/usr/bin/env bash

# reallynice.sh: don't hog the CPU, the disk, or the network.
# see https://github.com/pepaslabs/bash_scripts


# tunables:

# trickle download / upload limits (KB/s)
drate=500
urate=50


# functions:

function has()
{
    local cmd="${1}"
    which "${cmd}" >/dev/null 2>&1
}


# main:

nice_cmd=""
if has nice
then
    nice_cmd="nice"
fi

ionice_cmd=""
if has ionice
then
    ionice_cmd="ionice -c3"
fi

trickle_cmd=""
if has trickle
then
    trickle_cmd="trickle -s -d ${drate} -u ${urate}"
fi

cmd="${nice_cmd} ${ionice_cmd} ${trickle_cmd} ${@}"
eval "${cmd}"

