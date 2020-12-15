# frozen_string_literal: true

_timestamp, schedule = File.readlines(ARGV.first, chomp: true)

schedule = schedule.split(",").map(&:to_i).each_with_index.reject { |n, _| n.zero? }
t = 0
product = 1

schedule.each do |n, i|
  t += product while (t + i) % n != 0
  product *= n
end

puts t
