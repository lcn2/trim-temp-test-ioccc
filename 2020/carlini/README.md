# Best of show - abuse of libc

Nicholas Carlini <nicholas@carlini.com>  
<https://nicholas.carlini.com>  


The code for this entry can be found in prog.c

## Judges' comments:
### To use:

    make
    ./prog


### Try:

    # Play with a friend, P1 and P2, squares are numbered 1..9
    ./prog


### Selected Judges Remarks:

This program consists of a single print statement wrapped in a while loop. You
would not think that this would amount to much, but you would be very, very
wrong. A clue to what is happening and how this works is encoded in the
ASCII art of the program source.


## Author's comments:
HOW ABOUT A NICE GAME OF <strike>CHESS</strike>TIC-TAC-TOE?

### USAGE

    cc -o prog prog.c
    ./prog

Alternates between P1 and P2. Enter a digit [1-9] to move:

    1 | 2 | 3
    ---------
    4 | 5 | 6
    ---------
    7 | 8 | 9

The game ends if:

 * A player completes three in a row; that player wins
 * All squares are taken; neither player wins
 * A player makes an illegal move; their opponent wins


### LIMITATIONS

Bad things may happen if the entered move is outside of the range [1..9]

While the game will stop if one player tries to overwrite another player's move,
it will happily allow a player to move on top of themself. However, given that
this is an effective no-op and guarantees a loss to a competent opponent, if you
do this you probably deserve to lose.

Your terminal may beep at you every turn. We'll call this a feature that ...
the program ... is hard at work processing your move! That is! Please be
patient.

After macro expansion the format string is roughly 100K. This makes some
compilers unhappy, and others slow. (For example, passing GCC the flags -Wall
-Wextra -pedantic will result in a warning about oversized strings.)

Under some terminals the program may exit early. The following should always work:

    echo "1 2 3 4 5 6 7" | ./prog


### OBFUSCATION

The entirety of the program consists of a single iterated call to printf.

    int main() {
        while(*d) printf(fmt, arg);
    }

Here, `fmt` is a single string, and `arg` is a series of arguments to printf.

While its primary purpose is to serve as The One True Debugger, printf also happens
to be Turing complete. (See "Control-Flow Bending: On the Effectiveness of Control-Flow
Integrity" where we introduced this in an actual, published, academic paper. The
things you can get away with sometimes.)

We <strike>ab</strike>use this fact to implement the logic of tic-tac-toe entirely within
this one printf call (and a call to scanf() to read user input).

Here's (briefly) how it works.

#### Preliminaries

This program uses three printf format specifiers.
- `%d` takes an integer argument and prints it
- `%s` takes a string argument and prints it
- `%n` takes a pointer and writes (!!) the number of bytes printed so far.

Okay, everyone probably knows this. Let's get a bit more advanced.

Format specifiers can take extra "arguments".
- `"%hhn"`: store the number of bytes written mod 256 to the char pointer
- `"%2$d"`: print argument 2 to printf (and not the sequentially next argument)
- `"%8d"`: pad the printed integer to 8 characters
- `"%3$.*4$d"`: print argument 3 to printf with as many zeros as in argument 4.

For example, the following expression

    printf("%1$.*2$d%3$hhn", 5, 10, &x)

will have the same effect as if we had written

    x = 10;

because it will print out `0000000005` (5 padded to size 10) and then write the
number of bytes written to x.

#### Printf Oriented Programming

Alright, now we can get to the real fun.

We perform arbitrary computation with printf treating memory as a binary
array---one bit per pair of bytes:
- The zero bit is represented by the sequence `00 00`
- The one-bit is represented by the sequence `xx 00` where `xx` is any non-zero byte.

We can use format strings to compute the OR/NOT of arbitrary "bits".

We'll start with the simplest, OR:

    printf("%1$s%2$s%3$hhn", a, b, c)

will compute

    *c = strlen(a) + strlen(b)

but given that `strlen(x)` is `1` for a 1-bit and `0` for a 0-bit, we have

    *c = a | b

Computing the NOT of a single value is also easy:

    printf("%1$255d%1$s%hhn", a, b)

will compute

    *b = (strlen(a)+255)%256 = strlen(a)-1

and again, because `strlen(x)` is either `1` or `0` we have

    *c = !b

From here we can compute any binary circuit. Doing something efficient,
though, still takes work.

#### Tic-Tac-Toe

The game itself is represented as a board of 18 bits, 9 bits per player, along
with a turn counter that alternates between player 1 and player 2.

To detect who has won, we implement the following logic. Let A, B, and C be
pointers to three squares in a row to test, and D be where to save if there is a
win or not.

    "%A$s%B$s%C$s%1$253d%11$hhn" // r11 = !(*A & *B & *C)
    ZERO
    "%11$s%1$255d%11hhn" // r11 = !r11
    ZERO
    "%11$s%D$s%D$hhn" // *D = *D | r11

That is, we set `*D` to `1` if there is a three-in-a-row. We repeat this for all
possible three-in-a-row configurations, for both players.

The ZERO macro ensures that the number of bytes written out is 0 mod 256 with
the following expression

    "%1$hhn%1$s" (repeated 256 times)

where argument 1 is a pointer to a temporary variable followed by a null byte.

This works because if the current count is 0 mod 256, then "%1$hhn" will write
zero to argument 1 and then "%1$s" will never emit any text. If, on the other
hand, the count is not 0 mod 256, a length-1 string will be written to argument
1, and then "%1$s" will increment the count by one. By repeating this 256
times we're eventually going to reach 0 mod 256.

Checking if there has been an invalid move is achieved similarly.

In order to decide what to print out, we have to cast the "in-memory" array of
bits to Xs and Os to print out. This is actually rather straightforward. Given
in 1$ the pointer to player 1's square, and 2$ the pointer to player 2's, and
in 3$ the pointer to the board string, we can compute

    "%1$s" (repeated 47 times) "%2$s" (repeated 56 times) %1$32d%3$hhn"

which will, in effect, compute

    *r3 = (*r1) * 47 + (*r2) * 56 + 32

which will output ' ' if neither are true, 'X' if r1 is, or 'O' if r2 is.


#### Further Obfuscations

In order to be able to finally display the board, while still only using one
printf statement, we finish the statement with

    "\n\033[2J\n%26$s"

which is the escape sequence to clear the screen, and then prints argument 26.
Argument 26 is a pointer to a char* in memory, that initially is undefined,
but within the printf statement we will construct this string to look like a
tic-tac-toe board.

After the board, we need to print one of the following strings:

    P1>_
    P2>_
    P1 WINS
    P2 WINS
    P1 TIES
    P2 TIES

Depending on if it's P1 or P2's turn to move, the game is over and someone
won, or the game is over and it is a draw.

This turns out not to be as hard as it might look. Using the same trick as
before, we set byte four to be

    *byte4 = is_win * 'W' + is_tie * 'T'

The byte `'I'` and `'S'` can always be the same, and we do the same for `'E'`/`'N'`.

We do this same on-the-fly creation of the `scanf()` format string, but for a
different reason. We first want to run `printf()` to show the first board, and
then alternate between runs to `scanf()` and `printf()` reading and then
displaying moves. importantly, we *do not* want a final scanf when the game
ends. It should just exit.

One option would be to implement the logic as

    printf()
    while (*ok) {
        scanf();
        printf();
    }

but this would DOUBLE the number of calls to printf we require. So instead we
implement it like this

    while (*ok) {
        scanf();
        printf();
    }

(In reality we actually pass `scanf()` as an argument to avoid the extra
statement, but it has the same effect.)

Notice there is now no initial `printf()`. In order make sure the program doesn't
block before the first `printf()`, but we initialize the `scanf()` format to the null
string so that it returns right away without blocking. The first time the `printf()`
call runs, it writes out "%hhd" to create the `scanf()` format string.

-----------------------------------------------------------------------------------------------------
(c) Copyright 1984-2020, [Leo Broukhis, Simon Cooper, Landon Curt Noll][judges] - All rights reserved
This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License][cc].

[judges]: http://www.ioccc.org/judges.html
[cc]: http://creativecommons.org/licenses/by-sa/3.0/
-----------------------------------------------------------------------------------------------------
