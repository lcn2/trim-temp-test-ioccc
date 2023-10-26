# Best self documenting program

Hou Qiming\
<hqm03ster@gmail.com>

## To build:

```sh
make
```

## To use:

```sh
./hou 'expression'
```

## Try:

```sh
./hou '11/26+222/31'

./hou 'log((21701-19937)-(23209-21701))/log(2)'

./hou 'sin(1.5708)+0.04321+log(sqrt(exp(1*1*1)))+(1+2*3)-0.4-0.6+(4+6)*(2-1+2*3)-tan(0.785398)+2*10/3*6*sqrt(16/2/2)*10+10000-1000'

./hou 'a calculator expression -- see the C Code for details'
```

What does the last one mean?

## Judges' remarks:

This self-documenting scientific calculator compiles clean with no
warnings under the most strict pedantic mode of gcc and clang.

The first example, along with the correct result appears in the
source code. What does it mean?

The calculator obeys the precedence rules and allows parenthesis.

```sh
./hou '1+2*3'
./hou '(1+2)*3'
```

What exactly does the text formatting do?

What does this evaluate to in C?

```c
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
```

### Self documenting source

Comments would almost be redundant.  :-}

### The ASCII art is valid C code

... and not just fancy formatted comment removed by the C Pre-processor.

### The only multi-byte strings are format strings

The code does not contain some simple string-encoded lookup table for calculator
operations.

### Example input and output in the source

The example input and output in the C code is significant.  Can you find out
why?

### The button layout

The button layout in the C code is significant ... not just a nice looking
layout.

### input parsing

The parser is functionally equivalent to a normal arithmetic parser for all
valid inputs.  For another fun challenge: try to determine how it parses the
command line argument.

## Author's remarks:

### Obfuscations

This program is designed to be self-documenting. It doesn't just provide an
example command line. It also provides the expected output and illustrates all
supported functionality using embedded ASCII art.

- A few line numbers are significant and careless beautification will break the
program.
- The entire ASCII art is valid code. The preprocessor won't remove any part of it.
- The only strings longer than 1 byte are printf/sscanf format strings, even
after preprocessing. No string-encoded lookup table is used.
- The example input and its expected output are both algorithmically
significant.
- The button layout is also significant.
- The actual syntax being parsed is not that obvious, despite being functionally
equivalent for all correct inputs.

### Portability

- This program requires `argv` to point to writable memory. It doesn't require
the actual argv strings to be writable, though.
- This program requires ASCII.
- This program doesn't work with `%e` style numbers like `1e-4`.
- Some seemingly redundant code works to eliminate warnings and evade a gcc bug.

### Spoilers

The parser parses function names, subtraction, and division as single-letter
unary operators. A bitmask encoded hash table is used to check no-ops/digits
and another hash function maps the ASCII to a function ordinal, which is then
executed by the button panel.

Both hash functions were found using a separate search program. Another program
was used to find a way to format one hash function as example input such that
it produces something resembling the bitmask hash table as part of its output.

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
