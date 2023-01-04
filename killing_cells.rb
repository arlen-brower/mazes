require "grid"
require "recursive_backtracker"

grid = Grid.new(5, 5)

# orphan the cell in the northwest corner...
grid[0, 0].east.west = nil
grid[0, 0].south.north = nil

grid[1, 0].east.west = nil
grid[1, 0].south.north = nil

grid[0, 4].west.east = nil
grid[0, 4].south.north = nil

grid[1, 4].west.east = nil
grid[1, 4].south.north = nil

grid[1, 3].west.east = nil
# grid[1, 3].east.west = nil
grid[1, 3].north.south = nil
grid[1, 3].south.north = nil

grid[4, 0].east.west = nil
grid[4, 0].north.south = nil
# ... and the one in the southeast corner
grid[4, 4].west.east = nil
grid[4, 4].north.south = nil

RecursiveBacktracker.on(grid, start_at: grid[1, 1])

puts grid
