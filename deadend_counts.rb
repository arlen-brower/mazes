require "grid"
require "binary_tree"
require "sidewinder"
require "aldous_broder"
require "wilsons"
require "hunt_and_kill"
require "recursive_backtracker"

algorithms = [
  BinaryTree,
  Sidewinder,
  AldousBroder,
  Wilsons,
  HuntAndKill,
  RecursiveBacktracker
]

tries = 1000
size = 25

averages = {}

algorithms.each do |algorithm|
  puts "running #{algorithm}..."
  t1 = Time.now
  deadend_counts = []
  tries.times do
    grid = Grid.new(size, size)
    algorithm.on(grid)
    deadend_counts << grid.deadends.count
  end
  t2 = Time.now

  puts "    average runtime per maze: #{(t2 - t1) / tries} seconds"
  puts
  total_deadends = deadend_counts.inject(0) { |s, a| s + a }
  averages[algorithm] = total_deadends / deadend_counts.length
end

total_cells = size * size
puts
puts "Average dead-ends per #{size}x#{size} maze (#{total_cells} cells):"
puts

sorted_algorithms = algorithms.sort_by { |algorithm| -averages[algorithm] }

sorted_algorithms.each do |algorithm|
  percentage = averages[algorithm] * 100.0 / (size * size)
  puts "%14s : %3d/%d (%d%%)" %
         [algorithm, averages[algorithm], total_cells, percentage]
end
