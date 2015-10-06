#!/bin/bash

set -eu -o pipefail
set -x

nice ionice -c3 \
badblocks \
-w \
-p 1 \
-s \
-v \
-o log_$(date +%s).badblocks \
$@

