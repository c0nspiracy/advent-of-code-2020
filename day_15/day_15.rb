# frozen_string_literal: true

# Usage: ruby day_15.rb <starting_numbers> <max_turns>

input, max_turns = ARGV

input = input.split(",").map(&:to_i)
max_turns = max_turns.to_i

previously_spoken = {}
turn = 1
last_number = 0

input.each do |n|
  previously_spoken[n] = [turn, turn]
  last_number = n
  turn += 1
end

loop do
  ps = previously_spoken[last_number]
  n = ps.last(2).reduce(:-).abs

  previously_spoken[n] ||= [turn]
  previously_spoken[n] << turn
  last_number = n

  break if turn == max_turns

  turn += 1
end

puts last_number
