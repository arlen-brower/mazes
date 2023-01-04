require "color_distance_grid"
require "sidewinder"

grid = ColorDistanceGrid.new(10, 10)
Sidewinder.on(grid)

start = grid[0, 0]
distances = start.distances

grid.distances = distances
grid.r = 45
grid.g = 51
grid.b = 63
puts grid.to_s(true)

puts "\033[0mpath from northwest corner to southwest corner:"
grid.distances = distances.path_to(grid[grid.rows - 1, 0])
grid.r = 0
grid.g = 0
grid.b = 0
puts grid.to_s(false)
