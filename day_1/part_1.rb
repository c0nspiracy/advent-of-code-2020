# frozen_string_literal: true

entries = File.readlines('input.txt', chomp: true).map(&:to_i)
pair = entries.combination(2).detect { |a, b| a + b == 2020 }

puts pair.inject(:*)
