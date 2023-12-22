#!/usr/bin/env bash
#
# try.sh - demonstrate IOCCC winner 2020/kurdyukov2
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

# try finding convert(1) from ImageMagick
CONVERT="$(type -P convert)"


echo "$ (echo P6 1024 1024 255; dd if=/dev/urandom bs=3M count=1) > random.ppm" 1>&2
(echo P6 1024 1024 255; dd if=/dev/urandom bs=3M count=1) > random.ppm
echo "Look at random.ppm. Do you see any patterns?" 1>&2
read -r -n 1 -p "Press any key to continue: "
echo 1>&2
# Look at random.ppm. Do you see any patterns?
echo "$ ./prog_ppm 1000 random.ppm output.ppm" 1>&2
./prog_ppm 1000 random.ppm output.ppm
echo 1>&2
# See which patterns the program has found
echo "Now open output.ppm. What patterns has the program found?" 1>&2
echo 1>&2
read -r -n 1 -p "Press any key to continue: "
echo 1>&2

echo "$ for i in 0001 0002 0004 0008 0016 0032 0064 0128
  0256 0512 1024 2048 4096 8192 ; do ./prog $i sample.jpg out$i.jpg; done" 1>&2
for i in 0001 0002 0004 0008 0016 0032 0064 0128 0256 0512 1024 2048 4096 8192 ; do ./prog "$i" sample.jpg "out$i".jpg; done
echo "Now flip through out*.jpg and see when you start to recognise the image." 1>&2

if [[ -n "$CONVERT" ]]; then
    echo 1>&2
    read -r -n 1 -p "Press any key to create GIF: "
    echo 1>&2
    echo "$ $CONVERT -delay 10 -dither none -loop 0 $(ls out*.jpg | sort -V) $(ls out*.jpg | sort -rV) +map out.gif" 1>&2
    "$CONVERT" -delay 10 -dither none -loop 0 $(ls out*.jpg | sort -V) $(ls out*.jpg | sort -rV) +map out.gif
    echo 1>&2
    echo "Now look at out.gif with a viewer that can show animation." 1>&2
    echo "Warning: includes flashing colours." 1>&2
fi
