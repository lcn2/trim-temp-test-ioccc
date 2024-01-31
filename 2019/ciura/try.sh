#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 2019/ciura
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

echo "$ ./getwords.sh en | grep .. | ./prog aeiouvwxyz"
read -r -n 1 -p "Press any key to continue (space = next page, q = quit): "
echo 1>&2
./getwords.sh en | grep .. | ./prog aeiouvwxyz | less -rEXFK
echo 1>&2

echo "$ ./getwords.sh en | grep .. | ./prog aeiouhjklmnvwxyz" 1>&2
read -r -n 1 -p "Press any key to continue (space = next page, q = quit): "
echo 1>&2
./getwords.sh en | grep .. | ./prog aeiouhjklmnvwxyz | less -rEXFK

echo "$ ./getwords.sh en | grep .. | ./prog mrjocktvquizphdbagsfewlynx | head -n 256" 1>&2
read -r -n 1 -p "Press any key to continue (space = next page, q = quit): "
echo 1>&2
./getwords.sh en | grep .. | ./prog mrjocktvquizphdbagsfewlynx | head -n 256 | less -rEXFK


echo "$ ./en.sh" 1>&2
echo "There will likely be a lot of output. Quit when bored. No logophiles will be hurt." 1>&2
read -r -n 1 -p "Press any key to continue (space = next page, q = quit): "
./en.sh | less -rEXFK
