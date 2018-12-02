# Vic20MarioMaker
# TODO:
1. Creating 4 maps for the play mode
2. Store the map item indexes in play mode into the stack, make it store in a 22x23 matrix
3. Do the collison test, only test the ground and the future direction
4. Add live, score things like that to the game
5. Moving goomba

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
- $1006 - Mario X
- $1007 - Mario Y
- ..... - Reserve for missing items
- $1011 - Stack counter
- $1012 - Stack end pointer
- ..... - Space for the game map matrix



# About the matrix:
For every entity, it store the index of the item.
For the structure, read the matrix.jpg