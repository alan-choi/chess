The true interpretation of coordinates in doubly-nested arrays is to use the natural interpretation of the array when printed:

Array[row][col]

The first index is the row, with higher numbered rows being further down.
The second index is the column, with higher numbered rows being further right.

If the coordinates must be interpreted as x,y coordinates, then they should be accessed as array[y][x], which has inverted y direction but is otherwise consistent.

Luckily, this is mostly irrelevant, as swapping the two indexes everywhere calcels out.
