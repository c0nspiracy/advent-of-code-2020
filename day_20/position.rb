# frozen_string_literal: true

# Models the current position within a grid of image tiles
class Position
  attr_reader :row, :col

  def initialize(tile_count)
    @row = 0
    @col = 0
    @image_size = Math.sqrt(tile_count).to_i
  end

  def advance
    self.cell += 1
  end

  def cell=(cell)
    @row, @col = cell.divmod(@image_size)
  end

  def cell
    (@row * @image_size) + @col
  end

  def on_vertical_edge?
    first_row? || last_row?
  end

  def on_horizontal_edge?
    start_of_row? || end_of_row?
  end

  def start_of_row?
    @col.zero?
  end

  def end_of_row?
    @col == @image_size - 1
  end

  def first_row?
    @row.zero?
  end

  def last_row?
    @row == @image_size - 1
  end

  def position_of_tile_above
    ((@row - 1) * @image_size) + @col
  end
end
