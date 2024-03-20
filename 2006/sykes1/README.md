## To build:

```sh
make
```

There is an alt version based on the author's remarks. The [try.sh](try.sh)
script will compile and use both but if you wish to see the alternate version
specifically see the [Alternate code](#alternate-code) section below.


### Bugs and (Mis)features:

The current status of this entry is:

```
STATUS: INABIAF - please **DO NOT** fix
```

For more detailed information see [2006 sykes1 bugs](../../bugs.html#2006_sykes1).


## To use:

```sh
./sykes1
```

Next point your browser to the file: `sykes1.html`.


## Try:

```sh
./sykes1 10
```

Refresh your browser.

You might also try:

```sh
./try.sh
```

This will run both the original entry and the alt code to show some differences.


### Also try:

If you have all day :-) and wish to find out how fast your machine can solve the
maximum:


```sh
time ./sykes1 19186
```

This was done on a Rocky Linux 9.2 server with `Intel(R) Core(TM) i9-9900K CPU @
3.60GHz` with 16 cores (via HyperThreading):

```
real	6m35.524s
user	6m35.159s
sys	0m0.002s
```

and done with macOS Sonoma with the Max M1 chip:

```
real	7m10.786s
user	7m8.322s
sys	0m0.110s
```


## Alternate code:

This alternate code is based on the author's remarks.


### Alternate build:

```sh
make alt
```


### Alternate use:

Use `sykes1.alt` as you would `sykes1` above.


### Alternate try:

The [try.sh](try.sh) script will use both versions to show some differences. You
can do so like:

```sh
./try.sh
```


## Judges' remarks:

Read the [sykes1.html](sykes1.html) page source.
Now then read the C source.  Confused?  :-) If it's not clear try:

```sh
diff -s sykes1.c sykes1.html
```

For extra credit, understand what happens when you give this entry
an negative number argument, and why.

See the author's remarks for how to make your own shapes as well.


## Author's remarks:

This cube shaped program solves the fiendishly difficult "Bedlam Cube".

If you did not get one for Christmas, there is an [article about these
puzzles in wikipedia](http://en.wikipedia.org/wiki/Bedlam_cube).

Some instructions on how to make your own cube are in the included file
[bedlam-cubes.pdf](bedlam-cubes.pdf).

Finally, you can watch it being solved with the video file here,
[solving-bedlam-cube.mp4](solving-bedlam-cube.mp4).

Actually the cube is very hard to do by hand by just trying to fit it
together.  I have not known anyone to solve it in this way - you would
need to be very lucky indeed to stumble across a solution.


### Instructions

Compile the program, then test that it works:

```sh
./sykes1
```

Shortly you should see the first solution pop out on your screen.  It
shows you how to build the cube piece by piece, rendered in glorious
3D ASCII.

ASCII art is all very well, but you also have a web browser, right?  Well, just
open the file [sykes1.html](sykes1.html).  This html file is just a copy of
[sykes1.c](sykes1.c), which helpfully contains an html document that should make
the browser display for you a nice animated GIF, showing you how to build the
cube.  Rendered in glorious 3D color.

Want to see another solution?  Try:

```sh
./sykes1 some_number
```

The program will discard solutions up to the number, and output numbered
solution.  Refresh your browser window to see the new solution.

Try some more - there are exactly `19186` solutions to choose from.

If you have a fast machine you might try the last solution:

```sh
./sykes1 19186
```

On my machine this takes about half an hour to run.


### Implementation

The implementation is an optimized recursive algorithm that tries to fit
the pieces into the cube one by one.  The cube pieces are defined near
the start of the program:

```c
int s[ ] = { 186, 94, 1426, 3098
	,1047 , 122 , 1082 , 3083 , 1039
	, 569 , 527 , 1054 , 531  }  ;
```

Each piece is a bitmap, and represents a 3x3x3 cube.

For instance the first piece is `186` - this is `010111010` in binary.
Written out like this you can see that it is the cross shaped piece:

```
010
111
010
```

The other pieces are defined similarly. Most of the rest require more
than one layer, such as piece 3 (`1426`):

```
000
000
010

110
010
010
```

Imagine the two layers on top of each other, and you should see this
shape:

```
          +---------+
         / +----+  /|
        +-/    /| / |
        |+----+ |/  +
        ||    | +  /
        +|    |   /
         |    |  /
         |    | /
         |    |/
         +----+
```


### Making your own shapes

The program is in fact a general solver - you can change the shape of
the pieces, and provided that a solution is possible, it will be found.

For example, if you modify line 13 of the source like this, the program
will solve for a different piece set:

```c
int s[ ] = { 187, 94, 402, 3098
```

And of course you can make your own.

After the pieces are defined, the first thing the program does it to
fit them into a 4x4 cube.  It collects every possible placing of each
of the pieces.

Once those placings are ready, the program recursively checks each
combination thereof.

In order to complete in a reasonable time, care is taken to eliminate
any branches that cannot result in a solution. This is done by checking
after each placing if all the remaining pieces can be placed somewhere,
and that all the free space in the cube can be filled by at least one
viable placing.  Also if a piece is found to only have one possible
placing, it is placed immediately without invoking a recursive function
call.

Once the solution is found, the ASCII and GIF representations are
generated.  Care must be taken to render cubes in the right order such
that pieces further back are occluded by those in front.

In the ASCII output care must be taken with drawing the edges of each
`1/64th` cube (edges must be removed within each piece).  In the GIF
this is taken care of by color, which is graded from the back to the
front to ensure edge visibility.


### Notes

The whole program has just one function - `main()` - which is recursively
called.  In fact if you select solution 19186 it will be called exactly
`159,260,759` times.

If you pick a number higher than `19186`, the program will return a
solution but it will be a rotation of one of the first `19186`.  This is
because the cross shaped piece fits 48 ways in the 4x4 cube, but only
2 of those ways are unique - you can rotate one of those to make any
of the other 46.  The algorithm used always places the cross piece
first, so the first two placings of that piece result in the `19186`
unique solutions.

If you pick a number higher than `460464` (`24x19186`) the program will
return without outputting a solution.  If you can wait that long.

I recommend compiling with the most aggressive optimization options
your compiler supports.  I find `--unroll-loops` to be helpful with gcc.

The program relies on `long long int` being 64 bits, but has no other special
requirements.

The program is known to compile and run under gcc and Intel cc, as well
as PellesC on Windows.


### Bugs

The program is not at all a valid html document, but fortunately
browsers have good error recovery and amongst other things will ignore
the `/*` at the beginning, and won't mind the missing html and head tags
and the lack of end tags.

The generated GIF is not compressed.  This could be argued as an
advantage - at least I don't violate any of those old Unisys patents!

The pieces aren't really those colors.  Unless you make your own.


<!--

    Copyright © 1984-2024 by Landon Curt Noll. All Rights Reserved.

    You are free to share and adapt this file under the terms of this license:

	Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

    For more information, see:

	https://creativecommons.org/licenses/by-sa/4.0/

-->
