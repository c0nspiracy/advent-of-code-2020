# frozen_string_literal: true

layout = File.readlines(ARGV.first, chomp: true).map(&:chars)

# Models the waiting area from Day 11
class Grid
  DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def initialize(grid)
    @grid = grid
    @height = grid.length
    @width = grid.first.length
  end

  def count_occupied_seats
    @grid.join.count("#")
  end

  def run_simulation
    loop do
      changes = next_generation
      break if changes.empty?

      apply_changes(changes)
    end
  end

  private

  def next_generation
    each_position.each_with_object({}) do |(y, x, position), memo|
      next if position == "."

      visible_occupied_seats = find_visible_occupied_seats(y, x)

      if position == "L" && visible_occupied_seats.zero?
        memo[[y, x]] = "#"
      elsif position == "#" && visible_occupied_seats >= 5
        memo[[y, x]] = "L"
      end
    end
  end

  def each_position
    return enum_for(:each_position) unless block_given?

    @grid.each_with_index do |row, y|
      row.each_with_index do |position, x|
        yield y, x, position
      end
    end
  end

  def apply_changes(changes)
    changes.each { |(y, x), c| @grid[y][x] = c }
  end

  def find_visible_occupied_seats(y, x)
    DELTAS.count { |y_delta, x_delta| visible_occupied_seat?(y, x, y_delta, x_delta) }
  end

  def visible_occupied_seat?(y, x, y_delta, x_delta)
    loop do
      y += y_delta
      x += x_delta

      break unless y.between?(0, @height - 1)
      break unless x.between?(0, @width - 1)

      cell = @grid[y][x]
      return true if cell == "#"
      break unless cell == "."
    end

    false
  end
end

grid = Grid.new(layout)
grid.run_simulation

puts grid.count_occupied_seats
