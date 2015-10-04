#!/bin/bash

set -eu -o pipefail
set -x

badblocks \
-w \
-p 8 \
-s \
-v \
-o log_$(date +%s).badblocks \
$@

