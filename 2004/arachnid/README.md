# Best use of Vision:

    Nick Johnson
    25 Harvey Tce
    Richmond
    Christchurch
    New Zealand

    http://www.notdot.net/

# To build:

```sh
make
```

### To run:

```sh
./arachnid [mazefile]
```

### Try:

```sh
./arachnid arachnid.info
```

## Judges' comments

The fun part comes when you realize that the maze scrolls.  The overall
visual effect is quite pleasing (at least on some displays), and, well,
it's a lot of fun.

Navigation is through the use of the "wasd" inverted-T formation on
Qwerty keyboards.  Rogue players, vi users, and Dvorak typists are
invited to get lost!

## Author's comments

This program accepts ASCII formatted mazes as input, and renders
them onscreen for the user to explore, complete with Line Of Sight
- you cannot see parts of the maze your avatar (the '@') could not
have seen.

The maze files will be interpreted with spaces ' ' as gaps, tilde
'~' symbols (if any) as exits (which get represented as a NetHack
style '<' once loaded), and any other characters as walls.

Feed the program its own source for a default maze. Running it with
no command line parameters will do this. In a nice symmetry, the 
character constant '~' that recognises exits to input mazes itself 
forms the exit to the default maze. Another maze, 'maze1' has also 
been provided. This maze is 255x255, about the largest maze supported, 
for the particularaly insane maze explorers out there.

Usage:

```sh
./arachnid [mazefile]
```

You can explore the maze using the w,a,s, and d keys.
