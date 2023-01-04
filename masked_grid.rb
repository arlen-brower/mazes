require "grid"
require "chunky_png"

class MaskedGrid < Grid
  attr_reader :mask

  def initialize(mask)
    @mask = mask
    super(@mask.rows, @mask.columns)
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(row, column) if @mask[row, column]
      end
    end
  end

  def random_cell
    row, col = @mask.random_location
    self[row, col]
  end

  def size
    @mask.count
  end

  def distances=(distances)
    @distances = distances

    farthest, @maximum = distances.max
  end

  def background_color_for(cell)
    distance = @distances[cell] or return ChunkyPNG::Color.rgb(0, 0, 0)
    intensity = (@maximum - distance).to_f / @maximum
    dark = (255 * intensity).round
    bright = 128 + (127 * intensity).round
    ChunkyPNG::Color.rgb(dark, bright, dark)
    # ChunkyPNG::Color.rgb(bright, dark, dark)
    # ChunkyPNG::Color.rgb(bright, dark, bright)
    # ChunkyPNG::Color.rgb(dark, dark, bright)
  end
end
