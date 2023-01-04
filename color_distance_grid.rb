require "grid"

class ColorDistanceGrid < Grid
  attr_accessor :distances

  def distances=(distances)
    @distances = distances

    farthest, @maximum = distances.max
  end

  def contents_of(cell)
    if distances && distances[cell]
      distance = @distances[cell] or return nil
      intensity = (@maximum - distance).to_f / @maximum
      dark = (255 * intensity).round
      bright = 128 + (127 * intensity).round
      "\033[48;2;#{dark};#{bright};#{dark}m   \033[0m"
    else
      super
    end
  end

  def background_color_for(cell)
    if distances && distances[cell]
      distance = @distances[cell] or return nil
      intensity = (@maximum - distance).to_f / @maximum
      dark = (255 * intensity).round
      bright = 128 + (127 * intensity).round
      "\033[48;2;#{dark};#{bright};#{dark}m"
    else
      super
    end
  end

  def blend_colors(cell_one, cell_two)
    if distances && distances[cell_one] && distances[cell_two]
      distance_one = @distances[cell_one] or return reset_color
      distance_two = @distances[cell_two] or return reset_color
      intensity_one = (@maximum - distance_one).to_f / @maximum
      intensity_two = (@maximum - distance_two).to_f / @maximum
      intensity = (intensity_one + intensity_two) / 2.0
      dark = (255 * intensity).round
      bright = 128 + (127 * intensity).round
      "\033[48;2;#{dark};#{bright};#{dark}m"
    else
      super
    end
  end
end
