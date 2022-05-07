#!/bin/bash
#
# make.sh
#
# Script showing how to invoke Bazel.
# Informed by: https://youtube.com/watch?v=BGOEq5FdNUQ
#

set -e  # end script if there's an error

# If you are on Windows, you'll need to ask MSYS to not mangle
# Bazel targets, which it confuses for paths.  (So // becomes
# /, and you have to type ///).  Disable that behavior.
#
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

# You can actually ask Bazel to build "everything" with "..." but
# some shells convert ... to ../.. by default.  For compatibility
# quote the wildcard.
#
# bazel build '...'

bazel build -s //main:hello-world
bazel test //test:hello-test
