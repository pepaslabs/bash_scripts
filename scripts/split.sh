#!/bin/bash

set -e
set -o pipefail
set -x

split --verbose -d -b 1G "${1}" "${1}".
