# Bset slaml prragom

Ilya Kurdyukov  
<https://github.com/ilyakurdyukov>  
Twitter: @ilyakurdyukov  


The code for this entry can be found in prog.c

## Judges' comments:
### To use:

    make
    ./prog

### Try:

    # first input to try
    echo first input to try | ./prog

    # try reading this output
    echo International Obfuscated C Code Contest | ./prog

    # try reading this other output
    ./prog < input.txt

### Selected Judges Remarks:

It is interesting how well smeonoe can raed txet wtih lots of tyops in it.
How well can you raed porg.c, C prgoarm that is in the shpae of an SD card (or
is it a pnuch crad)?

## Author's comments:
### Letter Mixer ###

Compile and try this:

cat some.input.txt | ./prog

The program can work with letters that are not represented in English, as long as these letters are encoded in the higher part of the single-byte character set (use `iconv` to convert from UTF-8 and back).

-----------------------------------------------------------------------------------------------------
(c) Copyright 1984-2020, [Leo Broukhis, Simon Cooper, Landon Curt Noll][judges] - All rights reserved
This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License][cc].

[judges]: http://www.ioccc.org/judges.html
[cc]: http://creativecommons.org/licenses/by-sa/3.0/
-----------------------------------------------------------------------------------------------------
