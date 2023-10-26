# Best minimal use of C

Arch D. Robison\
US

## To build:

```sh
make all
```

### Bugs and (Mis)features

This entry a listed in [bugs.md](/bugs.md) as:

```
STATUS: INABIAF - please **DO NOT** fix
```

For more detailed information see [bugs.md](/bugs.md#1989robison-readmemd).


## To use:

```sh
./robison
# enter valid expressions
```

## Try:

```sh
./robison
11x10

echo 1x10x111 | ./robison

echo 1+1+10 | ./robison

echo 100 - 1 | ./robison

echo -100 x 100 + 1 | ./robison

echo 100 / 100 | ./robison # <-- what happens here ?
```

### INABIAF - it's not a bug it's a feature! :-)

This program will very likely crash or break into tiny bits :-) if you feed it
numbers with non-binary digits.

## Judges' remarks:

Sites with punch card facilities will be happy to note that
the source deck can be re-collated with an ASCII sort.

Note that this program uses only a small subset of the
constructs that the C language supports.

For an interesting document on APL, see
<https://computerhistory.org/blog/the-apl-programming-language-source-code/>.

## Author's remarks:

This program is a handy picoAPL interpreter written in `C--`.  It
outputs the evaluation of an
[APL](https://en.wikipedia.org/wiki/APL_(programming_language)) expression from standard
input.  Functions are limited to dyadic `+`,`-`,`x`, and unary `-`;
numerals must be binary.  Parentheses may be used for
grouping.  For example:

```
101x111-100
```

prints:

```
1111
```

That is `5x(7-4)` is `15`.  (APL groups from right to left.)
Extending it to the full APL language should be trivial.

The `C--` language improves the C language by removing superfluous
and confusing features: arithmetic, logical operations, shifts,
relational operators, address-of, and flow control.  In fact, the only
expressions retained are function calls, indirection, array
assignments, the ',' operator, and `sizeof`.  Despite these
restrictions, the `C--` program does arithmetic on arbitrarily
large binary numbers.

To obtain a `C--` reference, simply rip out the irrelevant pages
from your K&R C manual.  To obtain a `C--` compiler, simply rip
out the irrelevant bytes from your `cc` compiler.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
