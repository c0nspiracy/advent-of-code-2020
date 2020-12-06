# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

seat_ids = input.map do |line|
  row, col = line.tr("FLBR", "0011").scan(/.{3,7}/).map { _1.to_i(2) }
  row * 8 + col
end

puts seat_ids.max
