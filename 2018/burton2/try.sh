#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 2018/burton2
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


echo "$ ./prog -i < prog.c" 1>&2
./prog -i < prog.c

echo "$ ./prog -s < prog.c" 1>&2
./prog -s < prog.c

echo "$ ./prog -sk < prog.c" 1>&2
./prog -sk < prog.c

read -r -n 1 -p "Press any key to run: make test (space = next page, q = quit): "
echo 1>&2
make test | less -EXF