# frozen_string_literal: true

rows = File.readlines("input.txt", chomp: true)
rows.shift

trees = rows.each.with_index(1).count { |row, y| row[y * 3 % row.size] == "#" }

puts trees
