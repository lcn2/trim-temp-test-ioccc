#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 2020/giles
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

# try and find play(1). Should be available if SoX is installed.
PLAY="$(type -P play)"

if [[ -z "$PLAY" ]]; then
    PLAY="$(type -P aplay)"
    
    if [[ -z "$PLAY" ]]; then
	echo "Note: cannot find play(1) or aplay(1). Will not play sounds for you. Try installing" 1>&2
	echo "SoX. See FAQ 3.10: How do I compile and use an IOCCC winner that requires sound?" 1>&2
	echo 1>&2
	echo "You will have to play the WAV output manually, sorry." 1>&2
	echo 1>&2
    fi
fi

read -r -n 1 -p "Press any key to convert pi.wav to its digits: "
echo 1>&2
echo "$ ./prog < pi.wav" 1>&2
./prog < pi.wav
if [[ -n "$PLAY" ]]; then
    read -r -n 1 -p "Press any key to play pi.wav with $PLAY: "
    echo 1>&2
    echo "$ $PLAY pi.wav" 1>&2
    "$PLAY" pi.wav
fi

read -r -n 1 -p "Press any key convert 867-5309: "
echo 1>&2
echo "$ ./prog 867-5309 > jenny.wav" 1>&2
./prog 867-5309 > jenny.wav
if [[ -n "$PLAY" ]]; then
    read -r -n 1 -p "Press any key to play jenny.wav with $PLAY: "
    echo 1>&2
    echo "$ $PLAY jenny.wav" 1>&2
    "$PLAY" jenny.wav
    echo 1>&2
    read -r -n 1 -p "Press any key to play 10666-28 ('IOCCC-28'): "
    echo 1>&2
    echo "$ ./prog 10666-28 | $PLAY -"
    ./prog 10666-28 | "$PLAY" -
else
    echo 1>&2
    echo "Now try playing jenny.wav with an audio player that can play WAV files."
    echo 1>&2
    read -r -n 1 -p "Press any key to convert 10666-28 ('IOCCC-28'): "
    echo 1>&2
    echo "$ ./prog 10666-28 > ioccc28.wav"
    ./prog 10666-28 > ioccc28.wav
    echo 1>&2
    echo "Now try playing ioccc28.wav with an audio player that can play WAV files."
fi
