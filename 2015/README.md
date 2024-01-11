# 2015 marked the "The Twenty Fourth International Obfuscated C Code Contest"


## Standard IOCCC stuff

The IOCCC has a web site and now has a number of international mirrors.
The primary site can be found at,

* [http://www.ioccc.org/](http://www.ioccc.org/)

Use make to compile entries.  It is possible that on non-Un\*x / non-Linux
systems the makefile needs to be changed.  See the Makefile for details.

Look at the source and try to figure out what the programs do, and run
them with various inputs.  If you want to, look at the hints files for
spoilers - this year we included most of the information included
by the submitter.

Read over the makefile for compile/build issues.  Your system may require
certain changes (add or remove a library, add or remove a #define).

Some ANSI C compilers are not quite as good as they should be.  If
yours is lacking, you may need to compile using gcc instead of your
local compiler.


## Remarks on some of the winners

We believe you will again be impressed with this year's winners.

The fraction of worthy entries was higher than usual.

We call to your attention, the _hou_ entry, that performs the MD5
cryptographic hash.  Normally implemented with a set of integer and
boolean operations, this code uses floating point variables inside
a single while loop filled with unusual constants, cosine, square
root, and exponent function calls. The number of lines of code
is also smaller than the original algorithm.

The _mills2_ source code is a very compressed version of a decompression
algorithm.  We think those who enjoy compression algorithms will
particularly enjoy this entry.

We suggest that you attempt to completely understand the _endoh4_
1-liner program: another impressive compact piece of C code.

And while you are at it, cat the _endoh2_ prog.c code.  Compile it
and look at the source code again.

In a "Back to the Future" moment, _endoh3_ gave us a twist on one of
the all time best IOCCC winners from 1984.

We also suggest that you take a very good look at how the _muth_ code
makes full use of the C Pre-Processor.

...We'll stop spouting spoilers now. Have fun exploring all the entries!


## Remarks on some of submissions that did not win

The number of entries that would have made it into the final rounds
would have been much higher had some people paid attention to rules 2
and 22 (one third of 666).

Rule 22, now known as **Catch 22** states:

```
|  22) Your source code, data files, remarks and program output must NOT
|      identify the authors of your code.  The judges STRONGLY prefer to
|      not know who is submitting entries to the IOCCC.

|      The "Peter Honeyman is exempt" guideline also applies to this rule.
|      Identifying yourself, in an obvious way in your code, data, remarks
|      or program output, unless you are Peter Honeyman or pretending
|      to be Peter Honeyman, will be grounds for disqualification of your entry.
```

A number of other entries were based on iocccsize.c, making derivative works
rather than original works.

Still other entries were too large, violating the first line of rule 2:

2) The size of your program source must be <= 4096 bytes in length.

While these entries might have passed under the 2053 limit for iocccsize,
they were larger than <= 4096 bytes, sometimes by an order or magnitude.

We hope the authors of some of those entries will fix and re-submit
them for the next IOCCC.


## Final Comments

Please feel free to send us comments and suggestions about the
competition, this README or anything else that you would like to see in
future contests.

If you use, distribute or publish these entries in some way, please drop
us a line.  We enjoy seeing who, where and how the contest is used.

If you have problems with any of the entries, AND YOU HAVE A FIX, please
send us the fix (patch file or the entire changed file).

For the latest information on how to contact the IOCCC Judges please visit

* [http://www.ioccc.org/contact.html](http://www.ioccc.org/contact.html)

For news of the next contest watch:

* [http://www.ioccc.org/](http://www.ioccc.org/)


# Copyright and License

Copyright (C) 2015,2024, Landon Curt Noll and Leonid A. Broukhis. All Rights Reserved.
This work is licensed under a [Creative Commons CC BY-SA 4.0 DEED Attribution-ShareAlike
4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
If you do use this work in some form, the [IOCCC judges](/judges.html) would appreciate
(but does not require) if you were to [send us a note about your use](/contact.html).