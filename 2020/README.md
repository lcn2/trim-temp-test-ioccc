# Twenty Seventh International Obfuscated C Code Contest


## Standard IOCCC stuff

View the `index.html` web page for the given winning entry for information on how
on how to compile it and how to run the winning program.
Look at the winning source and try to figure how it does what it does!
You may then wish to look at the Author's remarks for even more details.

The primary site can be found at [www.ioccc.org](https://www.ioccc.org).

Use `make` to compile entries.  It is possible that on non-Unix / non-Linux
systems the Makefile needs to be changed.  See the Makefile for details.

Read over the Makefile and index.html files for compile/build issues.  Your
system may require certain changes (add or remove a library, add or remove a
`#define`).

Some C compilers are not quite as good as they should be.  If yours is
lacking, you may need to compile using clang or gcc instead of your local
compiler.


## Remarks on some of the winning entries

This year's [Best of Show (carlini)](carlini/index.html) is such a novel way of
obfuscation that it would be worth of a special mention in the (future) Best of
IOCCC list!

For some reason, this year's set of winning entries contains three nostalgic games,
[Asteroids (tsoj)](tsoj/index.html), [Minesweeper (endoh1)](endoh1/index.html),
and [Snake (ferguson1)](ferguson1/index.html).

An entry ([kurdyukov1](kurdyukov1/index.html)) pays homage to previous entry
[2015/hou](2015/hou/index.htm0).

...We'll stop spouting spoilers now. Have fun exploring all the entries!


## Remarks on some of submissions that did not win

As a rule, we try to compile the entries on a variety of platforms.  Quite a few
entries this year could not be built or executed on some of them due to reliance
on library internals or the system runtime.

A few entries were violating the "2053 significant bytes" rule. If an entry
could not be brought to compliance within a few seconds of looking at the
source, it was disqualified.

One entry tried to get around the size limit by putting the code into
Makefile variables and using `-D`. This is already called out as discouraged
technique in the guidelines, but it is worth a reminder.

Several promising entries attempted to make use of the `syscall` function using
literal syscall numbers.  This is utterly non-portable.

A note to the authors: when submitting multiple entries, don't let us easily
correlate them by coding style or documentation content, and definitely don't
submit nearly identical versions of your program separately. As we try to judge
the entries anonymously, the similarities will cause such entries to compete
against one another, making each less likely to win.

We hope the authors of non-winning entries will refine their entries and
perhaps re-submit them for the next IOCCC.


## Final Comments

One more thing that feels dated is digraphs and trigraphs.

**IMPORTANT NOTE**: See [contact.html](../contact.html) for up to date contact details
as well as details on how to provide fixes to any of the entries.
See also [the IOCCC FAQ](../faq.html) for addition information on the IOCCC.


# Copyright and License

Copyright (C) 2020,2023, Landon Curt Noll and Leonid A. Broukhis. All Rights Reserved.
This work is licensed under a [Creative Commons CC BY-SA 4.0 DEED Attribution-ShareAlike
4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
If you do use this work in some form, the [IOCCC judges](../judges.html) would appreciate
(but does not require) if you were to [send us a note about your use](../contact.html).
