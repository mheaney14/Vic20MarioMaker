# Vic20MarioMaker
# TODO:
1. Creating 4 maps for the play mode
2. Store the map item indexes in play mode into the stack, make it store in a 22x23 matrix
3. Add the moving function, which is easy with the new print function
4. Do the collison test, only test the ground and the future direction
5. Add live, score to the game
6. Moving goomba
7. Background music and sound effect
8. ......

# Memory Map
We are using BASIC memory for storing, which starts from $1000 - $1bff

- $1000 - Current map number
- $1001 - Game time
- $1002 - lives
- $1003 - score
- $1004 - music time (time for bgm)
- $1005 - Mario status 
        - 1. living
        - 2. dead
        - 3. mushroom?
- $1006 - Current X Position
- $1007 - Current Y Position
- $1008 - Current character symbol
- ..... - Reserve for missing items
- $1011 - Stack counter
- $1012 - Stack end pointer
- $1013 - Start of stack, using the format: MapLevel x y characteSymbol x y characterSymb 
- ..... - Space for the game map matrix

# About the matrix:
For every entity, it store the x, y and the character symbol into the stack in such specific order. Map level will be printed at the beginning of the stack, start at #51 (because x,y and type of symbol won't be around that number). The basic structure would be
51 x y Character x y Character x y Character 52 x y Chracter x y Character

# *New CHROUT way:
We don't have to use D1 and D3 anymore for print.
    ldx #1          ; Row
    ldy #1          ; Column
    clc             ; Clear carray flag
    jsr $fff0       ; Plot - move the cursor there
    lda #'A         
    jsr CHROUT
