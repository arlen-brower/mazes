require "colored_grid"
require "wilsons"

6.times do |n|
  grid = ColoredGrid.new(25, 25)
  Wilsons.on(grid)

  middle = grid[grid.rows / 2, grid.columns / 2]
  grid.distances = middle.distances

  filename = "wilsons_%02d.png" % n
  grid.to_png.save(filename)
  puts "saved to #{filename}"
end
