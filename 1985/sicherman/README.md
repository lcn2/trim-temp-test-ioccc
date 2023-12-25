## To build:

```sh
make all
```

There is another version that will be compiled in case the first fails. This
should happen automatically. See [Alternate code](#alternate-code) below for
more details on it.


## To use:

```sh
./sicherman < file

echo foo | ./sicherman

./sicherman
# type or paste some text, making sure to hit enter after each line typed
```


### Try:

```sh
./try.sh
```


## Alternate code:

The [sicherman.alt.c](sicherman.alt.c) is a slight change in the fixed version
(fixed so it does not require `-traditional-cpp`) in that it has two args to
`main()` as some compilers object to certain number of args in `main()`. This
will be built in the case of the [sicherman.c](sicherman.c) failing to compile.
In this case it'll be compiled to `sicherman` to simplify it for the larger
audience.


### Alternate build:

Although this will be built if the original fails to compile you can do it
manually like:

```sh
make alt
```

In this case it will be built as `sicherman.alt`.


### Alternate use:

```sh
./sicherman.alt < file
```


### Alternate try:

```sh
./try.alt.sh
```


## Judges' remarks:

This program abuses the C preprocessor so much that some `cpp`s fail to strip
out all of the comments on the first pass!  If you were able to understand
[Decot's](/winners.html#Dave_Decot) [entry in 1984](/1984/decot/README.md), you
will have a head start on this one.

Be sure to run this program through lint!  If your lint works
correctly, it should warn you that the argument 'Manual' isn't used.
Like the program says, what's that mean?

Run the program without arguments and enter the letters 'a' through 'm'
on a line.  Now enter the letters 'n' through 'z'.  But to borrow a quote
from Richard Stallman: If you think you understand what this code
does, then you don't, so read it again!  Explain why:

```sh
./sicherman < sicherman.c | ./sicherman | diff - ./sicherman.c
```

results in diff reporting a difference on some machines.


## Author's remarks:

No remarks were provided by the author.


## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
