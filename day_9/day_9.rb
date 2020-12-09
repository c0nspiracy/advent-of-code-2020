# frozen_string_literal: true

preamble_length = 25
data = File.readlines("input.txt", chomp: true).map(&:to_i)

preamble = data[0, preamble_length]
valid_nexts = preamble.combination(2).map { |pair| [pair, pair.sum] }
invalid_number = nil

data[preamble_length..].each do |current_number|
  unless valid_nexts.map(&:last).include?(current_number)
    invalid_number = current_number
    break
  end

  removed = preamble.shift
  valid_nexts.reject! { |pair, _| pair.include?(removed) }
  valid_nexts.concat(preamble.product([current_number]).map { |pair| [pair, pair.sum] })
  preamble.push(current_number)
end

puts "Part 1: #{invalid_number}"

(2..data.length).each do |range_size|
  if (range = data.each_cons(range_size).detect { |chunk| chunk.sum == invalid_number })
    puts "Part 2: #{range.minmax.sum}"
    break
  end
end
