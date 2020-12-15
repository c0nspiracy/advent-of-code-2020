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
waypoint = Vector[1, 10]

instructions.each do |action, value|
  case action
  when "L"
    waypoint = ROTATION[360 - value] * waypoint
  when "R"
    waypoint = ROTATION[value] * waypoint
  when "F"
    ship += waypoint * value
  when "N"
    waypoint += Vector[value, 0]
  when "S"
    waypoint -= Vector[value, 0]
  when "E"
    waypoint += Vector[0, value]
  when "W"
    waypoint -= Vector[0, value]
  end
end

puts ship.sum(&:abs)
