## To build:

If you don't have curses or SDL1 installed both modes will fail to compile. In
that case see the [FAQ 3.8 - How do I compile an IOCCC winner that requires SDL1
or SDL2?](/faq.md#SDL) and [FAQ 3.9  - How do I compile an IOCCC winner that
requires (n)curses?](/faq.md#faq3_9) for more information.


```sh
make alt
```

We recommend that you use the alternate code in modern systems. See the
[original code](#original-code) section for more details on why this is.


## To use:

```sh
./thadgavin.alt
```

You can press 'q' at any time to exit.


### Try:

If you have SDL1 installed:

```sh
./thadgavin_sdl
```

Whereas the curses version has an early exit the SDL version does not. You will
have to kill it yourself.

You might also care to reconfigure the speed at which the programs run. The code
calls `usleep(3)` with two default values, one for SDL and one for curses. The
curses and SDL macros are defined in the Makefile in a way that makes it easy to
redefine the values: `SLEEP` is how long the program sleeps (in microseconds)
between output with curses and `SDL_SLEEP` is how long it sleeps (also in
microseconds) for the SDL version.

To change the SDL one to something like `15000` you can do:

```sh
make SDL_SLEEP=15000 clobber alt
```

and to change the curses one to `40`:

```sh
make SLEEP=40 clobber alt
```

Then use the program(s) in the same way.

The different macros is because the curses version is already much slower and so
it's better to not tie the two values together. You may of course redefine both
in the same command.


## Original code:

WARNING: if you are sensitive to rapid movement or if you want to see better
what is going on then please use the alternate code as described above. If you
wish to see the original entry see below.

NOTE: in curses mode you might want to type `reset` after execution of this
program as the program does not call `endwin()`. Using `reset` will clear the
screen. The alt code, as noted above, allows one to quit early so this is not a
problem there.


### Original build:

```sh
make all
```


### Original use:

```sh
./thadgavin
```


### Original try:

If you have SDL1 installed:

```sh
./thadgavin_sdl
```


## Judges' remarks:

This entry is a nice play by the rules. It can use curses, if the
SDL graphic library is not present, and is quite good at that,
but the colors used in graphic mode (16 bit depth) are unfortunately
less than dazzling. We could not test this entry in DOS mode.


## Authors' remarks:

### To use under DOS:

Compile using DJGPP as follows:

```sh
gcc thadgavin.c -o thadgavin.exe -Wall -lm -O6 -mpentium -fomit-frame-pointer -ffast-math
```


### To use under Windows, X-Windows or macOS using the Simple DirectMedia Layer:

```sh
gcc -O6 -lpthread -g -o thadgavin thadgavin.c -lSDL -DSDL -lm
```


### To use curses:


```sh
gcc -O6 -lpthread -g -o thadgavin thadgavin.c -lncurses -lm
```


### Warnings

In gcc you might get the following warning:

```
thadgavin.c.c:46: warning: passing arg 2 of `SDL_SetColors' from incompatible pointer type
```

In Microsoft Visual Studio you may get warnings as follows:

```
thadgavin.c(46) : warning C4133: 'function' : incompatible types - from 'unsigned
char *' to 'struct SDL_Color *'
thadgavin.c(63) : warning C4026: function declared with formal parameter list
thadgavin.c(77) : warning C4244: '=' : conversion from 'double ' to 'unsigned
char ', possible loss of data

```

But don't worry, this is completely normal.

### Recommended dosage:

At least 3 minutes taken 3 times a day when tired.

Do not exceed 3 times recommended dose.  May cause sickness, dizziness, nausea.


## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
