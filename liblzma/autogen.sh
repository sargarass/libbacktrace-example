#!/bin/sh

###############################################################################
#
# Author: Lasse Collin
#
# This file has been put into the public domain.
# You can do whatever you want with this file.
#
###############################################################################

# The result of using "autoreconf -fi" should be identical to using this
# script. I'm leaving this script here just in case someone finds it useful.

set -e -x

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  autoreconf --force -v --install
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
