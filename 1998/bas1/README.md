# Best Encapsulation:

    Bas de Bakker
    Pica, Centre for Library Automation
    Statenweg 154 B    (home address)
    3039 JN Rotterdam
    The Netherlands

## To build:

        make all

### To run

If lpr on your system can print PostScript:

	    ./bas1 | gunzip | lpr

else, while in X Window System,

	    ./bas1 | gunzip | gv -
or:

	    ./bas1 | gunzip | gs -sDEVICE=pgmraw -sOutputFile='|xv -' -

## Judges' comments

The output is supposed to be a 3D maze, but it is somewhat more
than that. If you've seen any of the Maurits Escher's works,
you'll know what we're talking about.

When trying to run the program with command line arguments, be generous.

## Author's comments

BEMAZING
========

"You're in a twisty little maze of beams, all different."

Bemazing is "amazing" taken one step (letter) further.  Bemazing
creates a 3D maze of beams.  Try to go from the entrance (the
unfinished beam in one corner) to the exit (the unfinished beam in the
opposite corner) or vice versa.

For maximum portability, Bemazing is not tied to any window system,
but creates postscript.  The picture it makes will fit on either A4 or
letter size paper.

In addition, because postscript is rather verbose, Bemazing creates
the postscript in gzip format, in order to save precious bits on your
hard disk for the latest version of GNU Emacs (after all, you wouldn't
want to use an editor without a psychoanalyze-pinhead function, now
would you).  Again for maximum portability, Bemazing will take special
care that the binary output will not contain any newline or return
characters that may get weird treatment on systems that do not use the
One True Line Separator.

NOTES
=====

Be sure to view the source with something that can display characters
`\240-\377`.  Use `LESSCHARSET=latin1`, `M-x` `standard-display-european` in
GNU Emacs etc.  The source does not use characters in the range
`\200-\237` (we are not an unnamed word processor that tends to create
HTML containing these control characters).

Because this is not the obfuscated postscript contest, the postscript
does not contain any "for", "if" or other control structures.  All the
logic is in the C code.  There are only a few straightforward "def"s,
because otherwise the output would become much larger.

Try running `Bemazing` with command line arguments and see what
happens.  (But note that the program only guarantees that there
actually is a route from entrance to exit if you run it without
command line arguments.)

## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
