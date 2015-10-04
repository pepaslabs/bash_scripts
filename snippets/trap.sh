#!/usr/bin/env bash

# "strict" mode
# thanks to http://stackoverflow.com/a/13099228
# thanks to https://sipb.mit.edu/doc/safe-shell/
set -o pipefail    # trace ERR through pipes
set -o errtrace    # trace ERR through 'time command' and other functions
set -o nounset     # set -u : exit the script if you try to use an uninitialised variable
set -o errexit     # set -e : exit the script if any statement returns a non-true return value
shopt -s failglob  # if a glob doesn't expand, fail.


# use a trap to automatically run a function when this script exits or fails.
function cleanup_at_exit()
{
    echo "Exiting!"
    echo "Cleaning up..."
    # fill in the implementation of this function as needed...
}
trap cleanup_at_exit EXIT


# demo:

function random_is_even() { return $(( $RANDOM % 2 )) ; }

if random_is_even
then
    echo "Success!"
    exit 0
else
    echo "Failure!"
    exit 1
fi
