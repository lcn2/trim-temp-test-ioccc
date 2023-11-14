#!/usr/bin/env bash
#
# try.sh - show IOCCC winner 1996/schweikh2
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

read -r -n 1 -p "Press any key to to run ./schweikh2: " 1>&2
./schweikh2
echo >&2

read -r -n 1 -p "Press any key to run: ./schweikh2 15 1 0 0/0 | head -n 15: " 1>&2
./schweikh2 15 1 0 0/0 | head -n 15
echo >&2

read -r -n 1 -p "Press any key one more time: " 1>&2
i=0
while ((i++<15)); do
    grep -v '#' schweikh2.c
done
