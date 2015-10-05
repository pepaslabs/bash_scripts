#!/bin/bash

set -eu -o pipefail
set -x

badblocks \
-w \
-p 3 \
-s \
-v \
-o log_$(date +%s).badblocks \
$@

