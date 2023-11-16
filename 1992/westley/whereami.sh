#!/usr/bin/env bash
#
# whereami - a wrapper script to westley.c that checks first the
# columns of the terminal, exiting if < 80 and otherwise try compiling
# westley.c (with make) and then if is already compiled or ends up being
# compiled it will be run with the specified args to this program.
#
# It is an error to not specify two args but it is not an error to specify args
# that are not numbers. The atoi(3) function typically returns 0 in that case
# which westley.c uses.
# 
# The reason to use this wrapper is because westley.c needs at least 80 columns
# to show the output right. Previously it required 80 column wrapping but in
# 2023 this limitation was removed, allowing it to work as long as there are at
# least 80 columns.

# make sure there are at least two args
if [[ "$#" -lt 2 ]]; then
    echo "usage: $0 lat long" 1>&2
    exit 1
fi

# make sure CC is set so that when we do make CC="$CC" it isn't empty. Doing it
# this way allows us to have the user specify a different compiler in an easy
# way.
if [[ -z "$CC" ]]; then
    CC="cc"
fi

# try getting the columns the simple way first: tput cols
COLUMNS="$(tput cols)"
if [[ "$?" -ne 0 ]]; then
    # if tput failed for any reason try stty(1) with awk(1):
    COLUMNS="$(stty size|awkf '{print $NF}')"
fi

if [[ "$COLUMNS" -lt 80 ]]; then
    echo "Your terminal must be at least 80" 1>&2
    echo "columns wide echo but yours is only" 1>&2
    echo "$COLUMNS, sorry." 1>&2
    exit 1
fi

make CC="$CC" all >/dev/null || exit 1

./westley "$1" "$2"
