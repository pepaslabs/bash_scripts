#!/usr/bin/env bash

# fuzz.sh: sleep for a random amount of time (up to 15 seconds by default).
# see https://github.com/pepaslabs/bash_scripts
#
# usage: fuzz.sh [seconds]
#
# add fuzz.sh to your crontab to prevent a group of machines from causing
# a "stampeded":
# 
#   * * * * * fuzz.sh && script_which_is_run_by_a_bunch_of_machines.sh
#
# see also https://twitter.com/hmason/status/238417862992199680

delay=${1:-15}
sleep $(( ${RANDOM} % ${delay} ))
