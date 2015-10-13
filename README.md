# maze
Solution for the 'Interstellar' problem at HP Code Wars 2015

# The problem:

## 23.	Interstellar
Do you like solving mazes?  We are sure you don’t, they are too easy to solve, and they can be solved by mice or even slime moulds! But this is in part because we make them too simple, we make them in two dimensions to be able to draw then on a 2D surface. But universe is 3D, well, or 4D if we include time (ignoring extra dimensions of string theory that are too compact to be useful for mazes larger than one atom [remove?]). 
So we need to write a program to solve a 4D or space-time maze, but remember the fourth dimension is time and time dimension has something special in our universe, you cannot go back in time. Like in a normal space maze where we quantize space, we are going to quantize space as well [remove?]. Of course you can change the speed while moving in this space-time maze, this means than when in a specific time slice you can move as much as you want thru the 3D space maze or even not move at all before you jump to the next time slice. Traveling in diagonal is not allowed, neither in space or time.
The maze may have multiple solutions you need to return the solution shortest in number of movements in space. [or just any, but how the result is going to be tested? or make the maze with only one possible solution]
Input
The first line will be the size of the space time of our maze: Nx, Ny, Nz, Nt, all of them are positive integers. All space-time values are integers and start by 0, if Nx = 2, for example, possible x positions are 0, 1 and 2. Second line is the starting point: Sx, Sy, Sz, St. St will be always 0, start of time. Third line is the ending point: Ex, Ey, Ez, Et. Where Et = Nt – 1, end of time.
After this, there are Nx * Ny * Nz rows, each row start by 3 numbers than are the x, y, z coordinates of one point in space and later there are Nt values representing the evolution in time of this point in the maze, possible values are an asterisk (*) for a wall you can´t cross or an underscore (_) for a space. 
Output
Output the number of steps followed by the path thru space-time in x, y, z, t coordinates. 

### Input example:
2 3 2 5
1 2 0 0
1 0 1 4
0 0 0 *_***
0 0 1 *__*_
0 1 0 *****
0 1 1 **__*
0 2 0 *_***
0 2 1 *__*_
1 0 0 ***_*
1 0 1 **___
1 1 0 *_***
1 1 1 **_**
1 2 0 __*_*
1 2 1 __**_

### Output Example:
9
1 2 0 0
1 2 0 1
0 2 0 1
0 2 1 1
0 2 1 2
0 1 1 2
0 0 1 2
1 0 1 2
1 0 1 3
1 0 1 4

# How to run the code:

'ruby maze_solver.rb < input.txt'
'ruby maze_solver.rb < test1.txt'

# PS:

The code will show the maze and all the possible solutions and at the end it shows a single solution at the format of the problem statemet.

This is just for giving whoever is using this code, some help. There is also a hidden function at the code to create mazes.

Have fun :)