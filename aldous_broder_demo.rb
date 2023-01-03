require "grid"
require "aldous_broder"

grid = Grid.new(25, 25)
AldousBroder.on(grid)

filename = "aldous_broder.png"
grid.to_png.save(filename)
puts "saved to #{filename}"

puts grid
