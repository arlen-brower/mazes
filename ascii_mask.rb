require "mask"
require "masked_grid"
require "recursive_backtracker"

abort "Please specify a text file to use as a template" if ARGV.empty?
mask = Mask.from_txt(ARGV.first)
grid = MaskedGrid.new(mask)
RecursiveBacktracker.on(grid)

start = grid[0, 1]
distances = start.distances

grid.distances = distances

filename = "masked.png"
grid.to_png.save(filename)
puts "saved image to #{filename}"
