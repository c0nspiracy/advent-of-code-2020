# frozen_string_literal: true

def count_trees(rows, x_offset)
  rows.each.with_index(1).count { |row, y| row[y * x_offset % row.size] == "#" }
end

rows = File.readlines("input.txt", chomp: true)
rows.shift

trees = []
trees << count_trees(rows, 1)
trees << count_trees(rows, 3)
trees << count_trees(rows, 5)
trees << count_trees(rows, 7)

rows.shift
even_rows = rows.select.with_index { |_, i| i.even? }
trees << count_trees(even_rows, 1)

puts trees.inject(:*)
