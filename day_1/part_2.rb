# frozen_string_literal: true

entries = File.readlines('input.txt', chomp: true).map(&:to_i)
triplet = entries.combination(3).detect { |a, b, c| a + b + c == 2020 }

puts triplet.inject(:*)
