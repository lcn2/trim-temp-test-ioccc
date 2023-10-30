# Second place award

Dave Decot

## To build:

```sh
make all
```

NOTE: there is an [alternate version](#alternate-code) which will only work if
you have an old enough compiler or a compiler that supports `-traditional-cpp`.
The original code was fixed in 2023 to not require this.


### Bugs and (Mis)features

The current status of this entry is:

```
STATUS: INABIAF - please **DO NOT** fix
```

For more detailed information see [1984 decot in bugs.md](/bugs.md#1984-decot).


## To use:

```sh
./decot
```

## Alternate code:

This alternate code, the original, requires a compiler that supports
`-traditional-cpp` or an old enough compiler. If you have such a compiler you
can use this version.

### Alternate build:

```sh
make alt
```

### Alternate use:

```sh
./decot.alt
```

## Judges' remarks:

This program prints out a string of garbage.

The judges also offer this one comment: understand remarks!


### Historical remarks:

Some new (in 1984) compilers disliked line 15 of the original source, so we
changed it from:

```c
for(signal=0;*k * x * __FILE__ *i;) do {
```

to:

```c
for(signal=0;*k *x * __FILE__ *i;) do {
```

To see what we mean look at the [original source file](decot.orig.c). The
[alternate code](decot.alt.c) is the version that has this modification. The
fixed version has instead:

```c
for(signal=0;*k *= * __FILE__ *i;) do {
```


## Author's remarks:

No remarks were provided by the author.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
