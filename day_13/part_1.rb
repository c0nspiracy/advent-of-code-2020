# frozen_string_literal: true

timestamp, schedule = File.readlines(ARGV.first, chomp: true)

timestamp = timestamp.to_i
schedule = schedule.split(",").reject { _1 == "x" }.map(&:to_i)

mins = schedule.map do |bus|
  [bus, bus - (timestamp % bus)]
end

bus, wait = mins.min_by(&:last)
puts bus * wait
