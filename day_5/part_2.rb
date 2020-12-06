# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

seat_ids = input.map do |line|
  row, col = line.tr("FLBR", "0011").scan(/.{3,7}/).map { _1.to_i(2) }
  row * 8 + col
end

seat_ids.sort!
my_seat_id = (seat_ids.first...seat_ids.last).to_a - seat_ids

puts my_seat_id
