#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 1994/horton
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


read -r -n 1 -p "Press any key to run: ./horton 3 2 1 0: "
echo 1>&2
./horton 3 2 1 0
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton 0 1 2 3: "
echo 1>&2
./horton 0 1 2 3
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton -1 -2 -4 -8: "
echo 1>&2
./horton -1 -2 -4 -8
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton -8 -4 -2 -1: "
echo 1>&2
./horton -8 -4 -2 -1
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton 42 -42 42 -42: "
echo 1>&2
./horton 42 -42 42 -42
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton -42 42 -42 42: "
echo 1>&2
./horton -42 42 -42 42
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton 100 -100 -200 200: "
echo 1>&2
./horton 100 -100 -200 200
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton -100 100 200 -200: "
echo 1>&2
./horton -100 100 200 -200
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton -4 4 -4 4: "
echo 1>&2
./horton -4 4 -4 4
echo 1>&2

read -r -n 1 -p "Press any key to run: ./horton 4 -4 4 -4: "
echo 1>&2
./horton 4 -4 4 -4
echo 1>&2

read -r -n 1 -p "Press any key to show gtface.c (space = next page, q = quit): "
echo 1>&2
less -rEXF gtface.c
echo 1>&2

read -r -n 1 -p "Press any key to show gtface.data (space = next page, q = quit): "
echo 1>&2
less -rEXF gtface.data
echo 1>&2
read -r -n 1 -p "Press any key to run: ./gtface < gtface.data: "
echo 1>&2
./gtface < gtface.data
echo 1>&2
