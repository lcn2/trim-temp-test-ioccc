#!/usr/bin/env bash
#
# giana.sh - demonstrate IOCCC winner 2014/maffiodo1 The Great Giana Sisters
#

# make sure CC is set so that when we do make CC="$CC" it isn't empty. Doing it
# this way allows us to have the user specify a different compiler in an easy
# way.
if [[ -z "$CC" ]]; then
    CC="cc"
fi

make CC="$CC" all >/dev/null || exit 1

# clear screen after compilation so that only the entry is shown
clear

# see if the user wants to override width and height
if [[ -z "$ROWS" ]]; then
	ROWS="480"
fi
if [[ -z "$COLS" ]]; then
	COLS="640"
fi

cat giana.level | ./prog "$COLS" "$ROWS" 1000 300 192 168 giana.rgba giana8.wav 5459393
