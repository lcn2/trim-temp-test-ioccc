# Best Game

Chris Mills  
Wyse Technology  
3471 N. 1st St.  
San Jose CA 95134  
USA  

## To build:

```sh
make all
```

## To run:

```sh
./cmills [starting_cash]
```

We used a patch from [Yusuke Endoh](/winners.html#Yusuke_Endoh) to get this to
work in modern systems (it resulted in a bus error otherwise). Thank you Yusuke
for your assistance!

[Cody Boone Ferguson](/winners.html#Cody_Boone_Ferguson) made this safer by
using `fgets()` instead of `gets()`. This avoids an annoying and potentially
alarming warning at compiling and/or linking and/or runtime that in some cases
is interspersed with the program's output. Thank you Cody for your assistance!

For the original code see the [1992 archive](/archive/archive-1990.tar.bz2).


## Try:

```sh
./cmills 5000
```


## Judges' remarks:


The Makefile uses several `-D` defines. The following is is a list of the macros
that may be changed:

- `-DM=<max bet allowed>`
- `-DN=<52 * number of decks used>`
- `-DX=<how to seed the rand() generator>`

The macro `V` should remain `void`.


## Author's remarks:

This is a blackjack program.  It does splits, doubling down, insurance, etc.

As best I can figure, it should be ANSI-compliant, as well as portable to BSD &
SysV (as well as the irritating compiler I was using which assumes `x=*p++`
means `x*=p++`!).  It is reasonably robust in its error handling---it won't let
you split, double, etc. unless you actually have the cash, etc.  To terminate
the program, hit EOF or type 0 or a negative number for you wager.

The way it deals with splits is particularly cool (IMHO).  You can split many
times, and it will show all hands as they are played.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
