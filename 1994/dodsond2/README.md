# Most Obfuscated Packaging

Don Dodson\
AG Communication Systems\
17239 N. 19th Ave. #1003\
Phoenix, AZ 85023\
US

## To build:

```sh
make all
```

## To run:

```sh
./dodsond2
```

## Judges' remarks:

Each year people find new ways to squeeze more and more out of the
contest rules.  Next year, entries that use compression utilities
to get around the size limit will find themselves squeezed out of
the contest!

### A historical note:

The original source code was submitted as a GZIP compressed file
that the _file(1)_ command reports as:

```
dodsond2.gz: gzip compressed data, last modified: Mon Aug 29 21:54:39 1994, max compression, from Unix, original size modulo 2^32 2652
```

The [dodsond2.gz](dodsond2.gz) file was submitted as source
in an effort to get around the 1994 version of Rule 2:

```
2) Your entry must be <= 3217 bytes in length.  The number of characters
   excluding whitespace (tab, space, newline), and excluding any ; { or }
   followed by either whitespace or end of file, must be <= 1536.
```

Indeed, when [dodsond2.gz](dodsond2.gz) is uncompressed, it is identical
to the [dodsond2.c](dodsond2.c) file you find today.

The IOCCC rules and guidelines were modified in an effort to address
this fun "_abuse of the rules_" style hack.

It is worth noting that without this compression "_abuse of the rules_"
style hack, the [dodsond2.c](dodsond2.c) is further obfuscated.

## Author's remarks:

Go searching for the Wumpus in the Caverns of Doom!  But be careful...
There are pits and bats waiting to seal your fate, as well as a\
stealthy robber lurking in the shadows.  Move through the rooms by\
typing the number of the adjacent room you wish to visit.  You can\
feel a breeze if there is a pit in an adjacent room.  A rustling sound\
will tell you that bats are nearby.  The scent of the evil Wumpus can\
be detected from 2 rooms away.

To win, you must find one or more arrows, determine where the Wumpus\
is, and shoot him, all without falling into a pit or becoming the\
next meal for the Wumpus.  To shoot an arrow, type `s`.  Then give a\
list of the rooms you want to shoot into.  The rooms must be\
connected in the order you list them, or else the arrow may bounce\
back and hit you.  An arrow can go through as many as four rooms.\
But beware that shooting an arrow and missing the Wumpus may
awaken him.

There is a robber who waits in an unknown room. If you enter
that room carrying an arrow, he will steal that arrow from you
and move to a new room.  If he steals all the arrows in the
Caverns, you may catch him and recover all of them.  Doing this
gives you a bonus on your score.

You can quit at any time by typing `q`.  Typing `i` will tell
you how many arrows you are carrying.  `l` prints the description
of the current room again.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
