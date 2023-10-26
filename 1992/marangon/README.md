# Best Game

Marangoni Andrea\
Department of Computer Science at Milano\
Via Pausula, 72\
62014 Corridonia (MC)\
Italy

## To build:

```sh
make all
```

## To use:

```sh
./marangon
```

## Judges' remarks:

The object is to refill the table with 5's, by incrementing or decrementing
numbers as needed.  It is the side effects that get you into trouble.  If you
are not careful, you may find things "at 6's and 7's".  :-)

NOTE: Some compilers have had trouble optimizing this entry.

NOTE: Some systems need to compile with `-ltermcap` as well as `-lcurses`.

NOTE: The original winning source `marangon.orig.c`, found in the archive
directory, assumed that exit returns a value which cause problems for some
systems where exit returns a void.  The file [marangon.c](marangon.c) avoids
this problem.

## Author's remarks:

It starts off by creating a table with number 5 in all places.  The CPU melts
the numbers and you must return them in original state.  When you increase a
number, all the other eight numbers next to it decrease and vice-versa.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
