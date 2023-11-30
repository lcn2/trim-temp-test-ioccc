## To build:

```sh
make
```


## To use:

```sh
./hamano < textfile > output.pdf
```


### Try:

```sh
./try.sh
```

The script will generate a number of PDF files and it will suggest you look at
them as well. You can read `hint.pdf` with a PDF reader like `acroread hint.pdf`
or `evince hint.pdf`. With macOS you can do `open hint.pdf` which by default
will open `Preview.app`. You may of course use your pdf viewer to open the file
directly instead.

One of the PDF files generated is this README.md file as a PDF, obfuscated, and
the PDF file will then be compiled as C (itself!) and executed so that it shows
README.md!

Another PDF file generated is obfuscated C code. Once this is done it will
compile the PDF as if it was C and then run it like:

```sh
echo 'int main(){puts("Hello World!");}' | ./hamano > hello.pdf
cc -Wno-implicit-function-declaration -xc hello.pdf -o hello2
./hello2 | gcc -Wno-implicit-function-declaration -xc - -o ./hello3
./hello3
```


## Judges' remarks:

This entry treads into a new territory for IOCCC - generating PDF files.

The originally submitted entry could have been thought of as a "Best abuse of
Ghostscript" winner.  :-)

The source code and rendered pages are obfuscated for humans (where
is the font?), and the submitted entry created PDF files that left Ghostscript
confused.

The results can be viewed with Acrobat Reader,
[evince](http://en.wikipedia.org/wiki/Evince) and Apple's
[Preview](https://en.wikipedia.org/wiki/Preview_(macOS)).

The updated version can also be viewed using Ghostscript.

There is something strange about the little flags in the output.
A search of English literature will provide a hint.  The conclusion
you might draw is too elementary.  :-)

So what do those flags really mean?

The [Dancing men
algorithm](http://en.wikipedia.org/wiki/The_Adventure_of_the_Dancing_Men) might
be useful.

Don't forget to take a look at the generated PDF. Perhaps you might even want
to compile the output with a C compiler.  When you run it, what does it
output?


## Author's remarks:

This program obfuscate text file into PDF file with [Dancing men
algorithm](http://en.wikipedia.org/wiki/The_Adventure_of_the_Dancing_Men).

Probably, the output PDF file is compliant with PDF 1.3 and it's also
available to compile as C code.

I've tested it with GCC 4.7 and Clang 3.0 with Linux, and the following
PDF Readers:

* Adobe Acrobat Reader
* Evince
* Ghostscript
* Xpdf

### Obfuscations

This program is obfuscated by using classical methods.  But can you find the
embedded font in the fragmented glyph?


## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
