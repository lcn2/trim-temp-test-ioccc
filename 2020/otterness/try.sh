#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 2020/otterness
#

# make sure CC is set so that when we do make CC="$CC" it isn't empty. Doing it
# this way allows us to have the user specify a different compiler in an easy
# way.
[[ -z "$CC" || ! -f "$CC" || ! -x "$CC" ]] && CC="cc"

make CC="$CC" all >/dev/null || exit 1

# clear screen after compilation so that only the entry is shown
clear

read -r -n 1 -p "Press any key to run: ./prog < cvikl.mid > output.mid: "
echo 1>&2
./prog < cvikl.mid > output.mid
echo "Now play output.wav in an audio player that can play MIDI files." 1>&2
echo 1>&2

read -r -n 1 -p "Press any key to run: ./prog < entertainer.mid > output2.mid: "
echo 1>&2
./prog < entertainer.mid > output2.mid
echo "Now play output2.wav in an audio player that can play MIDI files." 1>&2
echo 1>&2
