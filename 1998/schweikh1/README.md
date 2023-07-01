# CPP Abuse

Jens Schweikhardt  
DFN Network Operation Center  
Schlartaeckerweg 3 (Home address)  
D-71384 Weinstadt  
Germany    
<http://www.schweikhardt.net>  


## To build:

```sh
make all
```

An alternate version for this entry works with macOS. See the Alternate code
section below for more details.


## To run:

```sh
./schweikh1
```

### Alternate code:

As noted above the alternate version works with macOS but there are some
important notes as well as a description of how it works (spoilers for the
original version as well).

With a MacBook Pro Max with the M1 chip some header files report an
unsupported architecture and unsupported compiler (error, warning).
However the defines are still found okay.

For this alternate version you will need the command line tools which you can
install like:

```sh
sudo xcode-select --install
```

Finally as far as how this works if you look at line 55 you see a funny command.
This goes for both versions. Now the key are two magic numbers, one on a
different line shortly below the string. In the original the numbers are,
respectively, 44 and 46.  But how does this work? Well the string is:

```
"0gcc -ansi -E -dM -undef %s /usr/include/%s>r\0 ("
```

The first number means: the length starting from 0 up through the `>`. The
second number is the same starting point but up through the `\0` which is why
it's +2. Somehow it was basic intuition that made me figure out these two
numbers and a quick test confirmed it. But what happens if only the first number
is updated? Most of the output will be just `#define` by itself; in the cases
where there was text after that it was macros that certainly were not defined.
There might have been other errors as well.

This allows for opening the right files. The problem with the macOS is
`/usr/include` does not exist: instead it's
`/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include` which is why
the different command line and the different numbers.

To use this version use:


```sh
make alt
```

Use `schweikh1.alt` as you would `schweikh1` above.


## Judges' remarks:

What does it do?  It seems to print a list of system headers, perhaps
with words after them.  Curiously, if you look at the list of words
defined in a given standard header, they are never printed directly
after that header's name.  Ah-hah!  It's a conformance test for the
standard headers.

This code is a wonder; it's a wonder that it compiles.  I wonder
whether or not it should.  The innovative realization that you can
use special characters, such as `'\n'`, in `#file` directives alone
merits some recognition.

I've included most of the author's remarks; they're fairly thorough.
Do not read them if you want to figure this out yourself.  "Amendment
One" refers to "NA1", the add-on to C89 which added some fairly
crufty internationalization support.

NOTE: Some non-gcc compilers that are not fully ANSI standard do not
compile this entry correctly.  Using cc by default is not helpful
most of the time on this entry, because the program has a hardcoded
gcc invocation anyway.  Anyone who uses egcs and has no plain gcc
will need to frob the source anyway and can be expected to do the
right thing with `${CC}`. So use gcc.


## Author's remarks

Important! This program, if it compiles at all, is mis-compiled by many
compilers due to compiler bugs. It could be the "least likely
to compile and execute" in conjunction with preprocessor abuse.
When run, it is likely to uncover bugs in your system headers.

The program is run without arguments. If your compiler is buggy,
the most likely result is no output and/or an exit status of 1.

If Amendment One headers are missing you will see something like:

```
<iso646.h>:
gcc: /usr/include/iso646.h: No such file or directory
gcc: No input files specified
<wctype.h>:
gcc: /usr/include/wctype.h: No such file or directory
gcc: No input files specified
<wchar.h>:
gcc: /usr/include/wchar.h: No such file or directory
gcc: No input files specified
```

Bug your vendor for an upgrade.

The format of the info file is straightforward and described in the file
itself. Just load it in your favorite editor.

### Requirements

`gcc` (the GNU C compiler) must be available at runtime. It is assumed that your
C implementation keeps headers as files in the /usr/include directory. The info
file must be readable and reside in the current working directory. The current
working directory must be writable in order to create a temporary file (which is
removed upon program termination). In case you don't have gcc at runtime, not
all is lost if your compiler or preprocessor can produce a list of defined
macros in the format output by `gcc -dM`, i.e. lines of the form `#define MACRO
value`.

Edit the source at line 55 in this case.

### Background

ISO C has a very strict idea of visibility of identifiers. All possible
macros are explicitly enumerated. In a compliant implementation no other
macros can be defined, because you could write strictly conforming
programs that may fail to compile due to syntax errors: suppose
`<stdio.h>` defines `PIPE_BUF`, then the conforming

```c
#include <assert.h>
#include <stdio.h>    /*  <- or where the bogus macro is defined */
#include <string.h>
#define STR(x) #x
#define XSTR(x) STR(x)
int main (void)
{
   int PIPE_BUF = 0;
   assert (strcmp ("PIPE_BUF", XSTR (PIPE_BUF)) == 0);
   return 0;
}
```

is expected to compile and meet the assertion. If it does not, your
compiler compiles some other language than ISO C.

### Why I think my program is obfuscated

Not only is the program's purpose a thorough standard conformance
test, the source itself is a beast and has uncovered bugs in many
C compilers.

1. The token sequence after `#include` can consist of pp-tokens and
   "are processed just as in normal text." [ISO 6.8.2] The result
   must resemble one of the canonical forms, `"foo.h"` or `<bar.h>`.
   This lets us write things like

     ```c 
     #define HEADER "foo.h"
     #include HEADER
     ```

   I could not find a compiler rejecting this. However, if we're
   torturing the preprocessor a little more, by using token pasting,
   at least one compiler falls over.

   ```c
     #define H(x) <st##x##.h>
     #include H(dio)              /* expands to <stdio.h> */
   ```

   is rejected by tcc version 4.1.2, the TenDRA compiler:
   ```
   "t.c", line 3: Error:  
   [ISO 6.8.3.3]: Invalid result for '##' operator in macro 'H'.
   ```

   To be honest, I don't know if the rules for pp-tokens and token
   pasting don't forbid what I do (and tcc is correct in rejecting it).
   In this case, all other compilers I tried are buggy, or the Standard
   itself :-)

2. The `#line` directive allows to set a line number, and optionally
   a file name, i.e. modify `__LINE__` and `__FILE__`. Strange things
   happen if the file name contains a NUL byte -- which the Standard
   allows: in `#line num "file"` the `"file"` is an s-char-sequence per
   ISO 6.8.4. ISO 6.1.4 defines string literals as s-char-sequences,
   which may include octal escape sequences. Let's look at

   ```c
     #include <stdio.h>
     #line 42 "foo\0bar"
     int main (void) {
       printf ("%s %d\n", __FILE__, (int)sizeof __FILE__);
       return 0;
     }
   ```

   This is supposed to output `'foo 8'`. Here's what happens in RL:

   ```
   foo 4        gcc 2.7.2.1, lcc
   foo\0bar 9   tcc 4.1.2, Sunsoft cc turn "\0" into "\\0", ugh!
   ```

   (I have written a bug report for gcc. Newer versions and egcs are ok.)

3. The `%:` and `%:%:` digraphs test for conformance to Amendment One.

Ask your local guru if C allows the same case label in the same switch
statement to appear more than once. Ask him/her to think real hard.
The answer will be "no". The true guru will cite a constraint in
ISO 6.6.4.2. Then make fun of the guru's answer by waving `case __LINE__:`
under his/her nose. Easy money from a bet! Make sure your guru has
no chance to use Standardese weasel words as an escape: can I have

```c
  case <some_token>:
  case <some_token>:
```

in the same switch? (Note that you need the [invisible] newline. You
can generously allow the additional constraint that no `#undef`s or
`#define`s are allowed between the two cases.)

Lots of integer constants and string literals come into the source
via `__LINE__` and `__FILE__` which are redefined at various places.
Sometimes the `__FILE__` contains `\0` bytes; different strings or
characters are then accessed with offsets, say `10+__FILE__` or
`__LINE__+__FILE__` or `2[__FILE__]`. One integral constant in octal.
This makes the source and header input depend on ASCII.

A few old obfuscations, like one character identifiers, not too
many macros, a `goto O`, "needless" assignments to satisfy lint
with its "function value ignored" warnings. My lint has nothing
to complain.

There's more whitespace in the Standard than just space, tab and newline. In
particular, there are vertical tab and form-feed that can be used in certain
places (outside of preprocessing directives, i.e. they are not allowed from just
after the `#` up to the final newline. See 6.8 for details.) On many
implementations these appear as `^L` and `^K`. My source starts with an
extremely uncommon 32bit word consisting of `^L`, `^K`, `%` and `:`.  I have
grepped old winning entries for ^K, none of them contains one, so this is
something new -- after 14 years of IOCCC. Be sure to have enough paper in your
printer when you make a hard copy of the source...

While I'm at it, the rules state that only space, tab and newline
are ignored for the count (plus '`{`', '`}`', '`;`' followed by
whitespace). The mkentry.c program, however, uses `isspace()` which
returns nonzero for vtab and form-feed and other characters as well.
I could have used a lot more ^K and ^L probably undetected by your
counter but decided to err on the side of safety. I use a perl
script to compute the character count according to the rules.
The advantages of an independent clean room approach...

```perl
#!/usr/bin/perl -w
$/ = "\0";
$_ = <>;
s/[;{}][ \t\n]/\n/g;
s/[ \t\n]+//g;
print length ($_),"\n";

```

I have tried, as suggested in the guidelines, to let the code look
like ordinary C code. Apart from a few long lines I think I left
the indentation like I would in RL. You should however not try to
use indent on the source. The code is extremely fragile because of the
myriads of `__LINE__` macros -- indenting is a sure way to break
the program. Don't even think of maintaining that beast; I've
had my share of core dumps during development :-) A test suite
was used after every minor change to find out if the program still
does what it should.

From the goals: "To stress C compilers with unusual code."
That describes exactly my modest attempts...


## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
