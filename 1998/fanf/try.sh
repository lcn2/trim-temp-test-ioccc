#!/usr/bin/env bash
# 
# try.sh - demonstrate IOCCC winner 1998/fanf
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

echo "$ echo '((\a(\b(\c(d)))) e' | ./fanf" 1>&2
echo '((\a(\b(\c(d)))) e)' | ./fanf
echo 1>&2

echo "$ echo '
(\f\g\x
  (
    (g x) (f x)
  ) K K z
)'|./fanf" 1>&2
echo '
(\f\g\x
  (
    (g x) (f x)
  ) K K z
)'|./fanf
echo 1>&2


echo "$ echo '(\f(\f\g\x( (f((\a(g(b))) e)) (g x) ) K K z))' | ./fanf" 1>&2
echo '(\f(\f\g\x( (f((\a(g(b))) e)) (g x) ) K K z))' | ./fanf
echo 1>&2

echo "$ echo '
(Y\f\n
  ((= n 0)
   1
   (* n (f (- n 1)))
  )
)' | ./fanf" 1>&2

echo '(Y\f\n
  ((= n 0)
   1
   (* n (f (- n 1)))
  )
)' | ./fanf
