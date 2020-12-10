# frozen_string_literal: true

adapters = File.readlines(ARGV.first, chomp: true).map(&:to_i).sort

adapters.unshift(0)
adapters.push(adapters.last + 3)

counts = adapters.each_cons(2).map { _2 - _1 }.tally

puts counts[1] * counts[3]
