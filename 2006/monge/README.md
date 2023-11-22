## To build:

Make sure you have the SDL1 (not SDL2!) development environment installed.

```sh
make
```


### Bugs and (Mis)features:

The current status of this entry is:

```
STATUS: doesn't work with some platforms - please help us fix
STATUS: INABIAF - please **DO NOT** fix
```

For more detailed information see [2006 monge in bugs.md](/bugs.md#2006-monge).


## To use:

```sh
./monge expression ...
```


### Try:

```sh
./monge "z = 0" "z = z*z*z + c; Abs2(z) < 4"
```

Incorrect formulas will ungracefully crash the program.

This is supposed to happen.  As is written in the
[The Jargon File](http://catb.org/jargon/html/F/feature.html):

```
That's not a bug, that's a feature.
```


## Judges' remarks:

For those who are familiar with the previous [IOCCC winners](/winners.html),
this program is best described as "[1994/tvr](/1994/tvr/tvr.c) meets
[2001/bellard](/2001/bellard/bellard.c)". Here you have mouse-manipulated
fractals AND generated binary code, all in one package.

A more appropriate award could have been "Best abuse of the
rules", because on a non-x86-based architecture this program
is, quite predictably, a dud.

At the time of judging we were too mesmerized by the graphics
to realize it; and, after all, this entry does take a special
effort to work on both `i386` and `x86_64`. Portable it is! :)


## Author's remarks:

### For the impatient:

0. Compile using the Makefile, or just run:

```sh
gcc monge.c -o monge -O3 `sdl-config --libs --cflags`
```

1. Run:

```sh
./monge "z = 0" "z = z*z + c; Abs2(z) < 4"
```

2. Keep clicking with left or right button to zoom in or out.

3. Use the number pad `+` and `-` to increase/decrease the iteration count when
needed.

4. Enjoy, unless you're more interested in trying to understand how it works. :)

### Introduction

This is a fractal generator that supports custom formulas and real time zoom.
The program needs to be run with two arguments, the first being a semicolon
separated list of assignments to do once per pixel, and the second a semicolon
separated list of assignments and conditions that will be executed (and
conditions checked) for each iteration (up to the maximum).  Using the left and
right mouse buttons you will be able to zoom in and out (a la
[XaoS](https://github.com/xaos-project/XaoS)), the zooming algorithm is a bit
slower than `XaoS`'s but it should give slightly better results.

Formulas can use all `a-z` (lowercase) variables, and the special
variables `c` and `i` are respectively set by default to the
complex coordinate of the pixel and to the complex imaginary `i`.

All the constant numbers will be interpreted as real double values.  Each
expression must be an assignment (`[variable] = [expr]`) or a comparison with
`<` or `>` (`[expr1] < [expr2]` or `[expr1] > [expr2]`), and you can add spaces
as you like (as understood by the C function `isspace()`).

Supported operations and functions are:

Operation | Description
:-------- | :----------
`+,-,*,/`   | Arithmetic operations, priority of `*`,`/` over `+,-` is
	      respected.
	    |
`<,>`       | Compares the real parts of two complex numbers (the imaginary part
	    | is ignored). Any number of conditions is allowed, the iteration
	    | will just stop as soon as one of them fails.
`Abs2`      | Calculates the squared norm, i.e.: `Abs2(a+b*i)` is `(a*a+b*b)+0*i`.
`Re`        | Extract the real part, i.e.: `Re(a+b*i)` is `a+0*i`.
`Im`        | Extract the imaginary part, i.e.: `Im(a+b*i) is b+0*i`.
`Exp`       | Calculates the complex exponential, i.e. `Exp(a+b*i)` is
	    |  `e^a*(cos(b)+sin(b)*i)`
`Ln`	    | Calculates the principal value of the natural logarithm, i.e.
	      `Ln(a+b*i)` is `ln(a*a+b*b)/2` + `atan(b/a)*i`

Here are a few examples of fractals you can draw:

- Mandelbrot:

        ./monge "z=1" "z=z*z+c; Abs2(z)<4"

- Mandelbrot (return time variation):

        ./monge "z=c" "z=z*z+c; Abs2(z-c)>0.0001"

- Julia, for `c=0.31+i*0.5`:

        ./monge "z=c; c=0.31+i*0.5" "z=z*z+c; Abs2(z)<4"

- Julia (return time variation), `for c=0.31+i*0.5`:

        ./monge "z=c; c=0.31+i*0.5" "z=z*z+c; Abs2(z-c)>0.0001"

- Newton, for `x^3-1`:

        ./monge "z=c" "p=z; z=0.6666*z+0.3333/(z*z); Abs2(p-z) > 0.001"

- Newton-Mandelbrot:

```
./monge "z=0" "p=z; z=z-(z*z*z + (c-1)*z - c)/(3*z*z+c-1); Abs2(p-z) > 0.001"
```

- Phoenix, Mandelbrot version:

```
./monge "z=0; q=0" "t=z; z=z*z+Re(c)+Im(c)*q; q=t; Abs2(z)<4"
```

- Phoenix, Julia version for `c=0.56667-i*0.5`:

```
./monge "z=c; c=0.56667-i*0.5; q=0" "t=z; z=z*z+Re(c)+Im(c)*q; q=t; Abs2(z)<4"
```

### Compilation and portability

This program will only work on x86 (with an x87 FPU) or x86_64 machines,
but it requires the SDL library.

Another system requirement is the `mmap()` function (as `#define`d at the
beginning of the program). If it is not available the macro `M(a)` will have to
be replaced with a system dependent function that allocates readable, writable
*AND* executable memory (it will not be possible to make this program run on
paranoid systems (like OpenBSD IIRC) that do not allow `rwx` memory).

However I was able to compile and make work the program under
Linux (Debian/x86 and openSUSE/x86_64) and under Cygwin/x86. A
friend of mine was able to make it work under macOS too.

If you want you can change the window width and height, or the default
number of iterations (that one can be tweaked at runtime, anyway) by
changing the definitions of `W`, `H` and `I` at the beginning of the code.


### Caveats (I just a selected few of them!)

- The zooming speed depends on the speed of the computer.
- Incorrect formulas will ungracefully crash the program.
- Many SDL identifiers are hardcoded as number, this is safe up to ABI
  incompatibility.
- Better optimization could be done treating known real numbers as just one
  double, instead of adding a 0 imaginary part to treat them as complex
  numbers.
- There should be some way to switch from Mandelbrot to Julia with chosen
  parameter.

### Spoiler

Sure, I don't want to deprive you of the pleasure of digging
into the infernal mess created by my corrupted mind (writing
this remark I noticed that I was ending sentences with ';' instead
that with '.', and I worried for my sanity), but just in case...

I used many obfuscation techniques, including a few ones that
are different from the tricks used in most common IOCCC program
(more 'high level', in the sense that they require an understanding
of how all the program works to be worked out).

This program is a formula parser that outputs machine code that
calculates the formula and check the given conditions. The
machine code targets the x87 stack based
[FPU](https://en.wikipedia.org/wiki/Floating-point_unit), and it is almost
identical for x86 and x86_64 (except for the comparison
instructions, that have to be generated differently).  The
program keeps track of the FPU stack (the FPU has a cyclic stack
of 8 registers) and will automatically swap to and from the
main memory when required (i.e., adds instructions to the generated
machine code to take care of this issue).

The formulas are parsed recursively and machine code for the
inner iteration loop is also generated.

After generating the machine code, a big event loop creates (or
zooms into) the fractal executing the generated code when needed,
and then waits for input events.

The zooming algorithm works by remembering for each pixel the
floating point offset to where the value was actually calculated.
When zooming, the best match is searched, and if the offset is
too big (`>1`) the pixel is recalculated.


## Copyright and CC BY-SA 4.0 License:

This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
You are free to share and adapt this file under the terms of this license:

    Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

For more information, see: https://creativecommons.org/licenses/by-sa/4.0/
