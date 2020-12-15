# frozen_string_literal: true

layout = File.readlines(ARGV.first, chomp: true).map(&:chars)
height = layout.length
width = layout.first.length

loop do
  new_layout = Array.new(height) { Array.new(width, ".") }

  layout.each_with_index do |row, y|
    row.each_with_index do |position, x|
      adjacent_seats = []

      if y.positive?
        adjacent_seats << layout[y - 1][x - 1] if x.positive?
        adjacent_seats << layout[y - 1][x]
        adjacent_seats << layout[y - 1][x + 1] if x < width
      end

      adjacent_seats << layout[y][x - 1] if x.positive?
      adjacent_seats << layout[y][x + 1] if x < width

      if y < height - 1
        adjacent_seats << layout[y + 1][x - 1] if x.positive?
        adjacent_seats << layout[y + 1][x]
        adjacent_seats << layout[y + 1][x + 1] if x < width
      end

      occupied_adjacent = adjacent_seats.count("#")

      new_layout[y][x] = if position == "L" && occupied_adjacent.zero?
                           "#"
                         elsif position == "#" && occupied_adjacent >= 4
                           "L"
                         else
                           position
                         end
    end
  end

  break if new_layout == layout

  layout = new_layout
end

puts layout.join.count("#")
