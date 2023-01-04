require "cell"
require "chunky_png"

class Grid
  attr_reader :rows, :columns
  attr_accessor :r, :g, :b

  def initialize(rows, columns)
    @rows = rows
    @columns = columns

    @r = 214
    @g = 220
    @b = 230

    @grid = prepare_grid
    configure_cells
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(columns) { |column| Cell.new(row, column) }
    end
  end

  def configure_cells
    each_cell do |cell|
      row, col = cell.row, cell.column

      cell.north = self[row - 1, col]
      cell.south = self[row + 1, col]
      cell.west = self[row, col - 1]
      cell.east = self[row, col + 1]
      cell.southeast = self[row + 1, col + 1]
    end
  end

  def [](row, column)
    return nil unless row.between?(0, @rows - 1)
    return nil unless column.between?(0, @grid[row].count - 1)
    @grid[row][column]
  end

  def random_cell
    row = rand(@rows)
    column = rand(@grid[row].count)

    self[row, column]
  end

  def size
    @rows * @columns
  end

  def each_row
    @grid.each { |row| yield row }
  end

  def each_cell
    each_row { |row| row.each { |cell| yield cell if cell } }
  end

  def contents_of(cell)
    "   "
  end

  def background_color_for(cell)
    color = "\033[0m"
    color << black_foreground
    color
  end

  def reset_color
    color = "\033[0m"
    color << black_foreground
    color
  end

  def blend_colors(cell_one, cell_two)
    color = "\033[0m"
    color << black_foreground
    color
  end

  def black_foreground
    "\033[38;2;#{@r};#{@g};#{@b}m"
  end

  def to_s(borders = true)
    output = black_foreground
    output << "┏"
    each_row do |row|
      row.each do |cell|
        output << "━━━"
        cell.linked?(cell.east) ? output << "━" : output << "┳"
      end
      break
    end

    output << "\b┓\n"

    each_row do |row|
      top = "┃"

      first_cell = row[0]

      if first_cell.south == nil
        bottom = "┗"
      elsif first_cell.linked?(first_cell.south)
        bottom = "┃"
      else
        bottom = "┣"
      end

      row.each do |cell|
        cell = Cell.new(-1, -1) unless cell

        body = "#{contents_of(cell)}" # Three spaces
        east_boundary = (cell.linked?(cell.east) ? " " : "┃")

        if borders
          top << black_foreground << background_color_for(
            cell
          ) << body << blend_colors(
            cell,
            cell.east
          ) << black_foreground << east_boundary
        else
          top << black_foreground
          top << background_color_for(cell) << body << black_foreground
          top << blend_colors(cell, cell.east) if east_boundary == " "
          top << east_boundary
        end
        south_boundary = (cell.linked?(cell.south) ? "   " : "━━━")

        if cell.east == nil or cell.south == nil
          if cell.linked?(cell.south)
            corner = "┃"
          elsif cell.east == nil and cell.south == nil
            corner = "┛"
          elsif cell.east != nil and !cell.linked?(cell.east)
            corner = "┻"
          elsif cell.east != nil
            corner = "━"
          else
            corner = "┫"
          end
        else
          corner = "╋"
          corner = "┣" if (
            cell.linked?(cell.south) and !cell.linked?(cell.east)
          )
          corner = "┳" if (
            !cell.linked?(cell.south) and cell.linked?(cell.east)
          )
          corner = "┏" if (cell.linked?(cell.south) and cell.linked?(cell.east))

          if cell.linked?(cell.south) and cell.linked?(cell.east)
            if cell.south.linked?(cell.south.east)
              corner = "╺"
            elsif cell.east.linked?(cell.east.south)
              corner = "╻"
            else
              corner = "┏"
            end
          end

          if !cell.linked?(cell.south) and cell.linked?(cell.east)
            if cell.south.linked?(cell.south.east) and
                 cell.east.linked?(cell.east.south)
              corner = "╸"
            elsif cell.south.linked?(cell.south.east)
              corner = "━"
            elsif !cell.east.linked?(cell.east.south)
              corner = "┳"
            else
              corner = "┓"
            end
          end

          if cell.linked?(cell.south) and !cell.linked?(cell.east)
            if cell.south.linked?(cell.south.east) and
                 !cell.east.linked?(cell.east.south)
              corner = "┗"
            elsif cell.east.linked?(cell.east.south)
              corner = "┃"
            end
          end

          if !cell.linked?(cell.south) and !cell.linked?(cell.east)
            if cell.south.linked?(cell.south.east) and
                 cell.east.linked?(cell.east.south)
              corner = "┛"
            elsif cell.south.linked?(cell.south.east) and
                  !cell.east.linked?(cell.east.south)
              corner = "┻"
            elsif cell.south.linked?(cell.south.east)
              corner = "━"
            elsif cell.east.linked?(cell.east.south)
              corner = "┫"
            end
          end
        end
        if borders
          bottom << black_foreground << blend_colors(
            cell,
            cell.south
          ) << south_boundary << blend_colors(
            cell,
            cell.southeast
          ) << corner << reset_color
        else
          bottom << black_foreground
          bottom << blend_colors(cell, cell.south) if south_boundary == "   "
          bottom << south_boundary << reset_color << corner << reset_color
        end
      end

      output << black_foreground << top << reset_color << "\n"
      output << black_foreground << bottom << reset_color << "\n"
    end

    output
  end

  def to_png(cell_size: 10)
    img_width = cell_size * columns
    img_height = cell_size * rows

    background = ChunkyPNG::Color::WHITE
    wall = ChunkyPNG::Color::BLACK

    img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, background)

    %i[backgrounds walls].each do |mode|
      each_cell do |cell|
        x1 = cell.column * cell_size
        y1 = cell.row * cell_size
        x2 = (cell.column + 1) * cell_size
        y2 = (cell.row + 1) * cell_size

        if mode == :backgrounds
          color = background_color_for(cell)
          img.rect(x1, y1, x2, y2, color, color) if color
        else
          img.line(x1, y1, x2, y1, wall) unless cell.north
          img.line(x1, y1, x1, y2, wall) unless cell.west

          img.line(x2, y1, x2, y2, wall) unless cell.linked?(cell.east)
          img.line(x1, y2, x2, y2, wall) unless cell.linked?(cell.south)
        end
      end
    end

    img
  end
end
