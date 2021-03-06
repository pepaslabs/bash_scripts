#!/usr/bin/env bash

# "strict" mode
# thanks to http://stackoverflow.com/a/13099228
# thanks to https://sipb.mit.edu/doc/safe-shell/
set -o pipefail    # trace ERR through pipes
set -o errtrace    # trace ERR through 'time command' and other functions
set -o nounset     # set -u : exit the script if you try to use an uninitialised variable
set -o errexit     # set -e : exit the script if any statement returns a non-true return value
shopt -s failglob  # if a glob doesn't expand, fail.


# _script: the name of this script
# _scriptdir: the directory which this script resides in
# thanks to https://github.com/kvz/bash3boilerplate/blob/master/main.sh
_script="$(basename "${BASH_SOURCE[0]}")"
_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# portable mktemp calls (works with BSD or GNU mktemp, e.g. OS X or Linux)
# thanks to http://unix.stackexchange.com/a/84980
function mktempfile() { mktemp 2>/dev/null || mktemp -t "${_script}" ; }
function mktempdir() { mktemp -d 2>/dev/null || mktemp -d -t "${_script}" ; }


# demo / usage of the above.

echo '$_dir: the path where this script resides:' "${_dir}"
echo '$_script: the name of this script:' "${_script}"

tempfile=$(mktempfile)
echo '$tempfile created:' "${tempfile}"

tempdir=$(mktempdir)
echo '$tempdir created:' "${tempdir}"

