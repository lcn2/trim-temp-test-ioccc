## To build:

```<!---sh-->
    make
```


## To use:

```<!---sh-->
    ./anonymous 'foo' > bar.pgm
```

Now open the output using your favourite
[pgm](https://en.wikipedia.org/wiki/Netpbm#PGM_example) viewer. If you don't
have a `pgm` viewer then we suggest the [netpbm
toolkit](https://netpbm.sourceforge.net) to convert the image to a graphics
format that you can view. Most graphical web browsers can display PNG or JPEG
images.


## Try:

```<!---sh-->
    ./try.sh
```

NOTE: technically the text is supposed to be in all lower case but the script
does use some upper case letters for demonstration purposes.


## Judges' remarks:

Did you know that in the first edition of The Hobbit Gollum was willing to give
up the ring? It was not the Ruling Ring, the One Ring, the Ring of Power or
anything like that: it was simply a literary device that could make one
invisible. When Bilbo won the famous riddle game Gollum went to fetch the Ring -
not to kill and eat Bilbo but to give it to him! But Bilbo had already found it
just like in the later editions. Gollum profusely apologised and begged for
forgiveness. Bilbo told him never mind because he would have had it anyway. But
he'd let him off on one condition: that he show him the way out. It was at this
point that Bilbo slipped the ring on and Gollum saw him vanish and understood
that he already found it. But there was no call of thief and no hatred of Bilbo.

If you want to read the first edition they reprinted it some years back: `The
Hobbit Facsimile First Edition`. The details are also discussed in History of
Middle-earth [HoMe] VI, [The Return of the
Shadow](https://tolkiengateway.net/wiki/The_Return_of_the_Shadow), part one of
the history of The Lord of the Rings of a twelve volume set - as well as in [The
History of the
Hobbit](https://tolkiengateway.net/wiki/The_History_of_The_Hobbit).

p.s. Frodo lives!


### An important aside :-)

BTW: if you haven't read [The Lord of the
Rings](https://en.wikipedia.org/wiki/The_Lord_of_the_Rings) what are you waiting for? :-)
You'll find out the source of the text above though you'll see that there are
some circumflexes missing! That's okay though due to I/O of the entry and in
earlier drafts sometimes the û had no diacritic but H after the `u` in
it. The real text is:

> Ash nazg durbatulûk, ash nazg gimbatul, ash nazg thrakatulûk, agh
> burzum-ishi krimpatul.

which when translated from [Black
Speech](https://www.glyphweb.com/arda/b/blackspeech.html) means:

> [One Ring](https://www.glyphweb.com/arda/o/onering.html) to rule them all, [One
Ring](https://www.glyphweb.com/arda/o/onering.html) to find them,\
> [One Ring](https://www.glyphweb.com/arda/o/onering.html) to bring them all and in the darkness bind them.


## Author's remarks:

This program takes a single command line argument, transcribes the
argument text into Tolkien's Elvish letters, and writes the
transcription to standard output as a [portable
graymap](https://en.wikipedia.org/wiki/Netpbm#PGM_example) (PGM) file.

The specific transcription mode is the [Black
Speech](https://www.glyphweb.com/arda/b/blackspeech.html) ([Tengwar
mode](https://www.glyphweb.com/arda/t/tengwar.html)), as
used in the inscription on the [One
Ring](https://www.glyphweb.com/arda/o/onering.html). The program handles the
following digraphs:

- `gh`, `sh`, `th`: the corresponding
[tengwar](https://www.glyphweb.com/arda/t/tengwar.html) are output for these
specific sounds.
- `mh` denotes the full [tengwa](https://www.glyphweb.com/arda/t/tengwar.html)
for `[m]`; `m` by itself means a horizontal bar above the next letter.
- `rh` denotes the `[r]` [tengwa](https://www.glyphweb.com/arda/t/tengwar.html).
- `uh` denotes the [tehta](https://www.glyphweb.com/arda/t/tehtar.php) for long
vowel `[u:]`.
- `zh` selects the up-reaching
[tengwa](https://www.glyphweb.com/arda/t/tengwar.html) for `[z]`, while `z`
selects the down-reaching one.

Punctuation marks other than commas and periods are ignored, as are
whitespace characters. In addition, the argument text must be entirely
in lower case.

The following command thus writes a rendering of the [Ring
inscription](https://www.glyphweb.com/arda/r/ringinscription.html) to
the file `ring.pgm`:

```<!---sh-->
    ./anonymous "ash nazg durhbatuluhk, ash nazg gimbatul, \
	ash nazg thrakatuluhk, agh burzhumh-ishi krimpatul." >ring.pgm
```

The source code assumes the ASCII character set; also, due to space
constraints, the program uses rather inefficient algorithms, so it may
waste a lot of time and space even when rendering moderately long
strings.

The code contains a vector font which was derived by toying with [Harri
Perälä](https://alboin.fi)'s [Tengwar Cursive
font](https://alboin.fi/tengwar.htm). Currently, only the glyphs used in the
[Ring inscription](https://www.glyphweb.com/arda/r/ringinscription.html) are
included in the font.


<!--

    Copyright © 1984-2024 by Landon Curt Noll. All Rights Reserved.

    You are free to share and adapt this file under the terms of this license:

	Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

    For more information, see:

	https://creativecommons.org/licenses/by-sa/4.0/

-->
