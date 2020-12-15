# frozen_string_literal: true

require "matrix"

ROTATION = {
  90 => Matrix[[0, -1], [1, 0]],
  180 => Matrix[[-1, 0], [0, -1]],
  270 => Matrix[[0, 1], [-1, 0]]
}.freeze

instructions = File.readlines(ARGV.first, chomp: true).map do |line|
  arg, n = line.scan(/^([A-Z])(\d+)$/).first
  [arg, n.to_i]
end

ship = Vector[0, 0]
facing = Vector[0, 1]

instructions.each do |action, value|
  case action
  when "L"
    facing = ROTATION[360 - value] * facing
  when "R"
    facing = ROTATION[value] * facing
  when "F"
    ship += facing * value
  when "N"
    ship += Vector[value, 0]
  when "S"
    ship -= Vector[value, 0]
  when "E"
    ship += Vector[0, value]
  when "W"
    ship -= Vector[0, value]
  end
end

puts ship.sum(&:abs)
