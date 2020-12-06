# frozen_string_literal: true

groups = File.readlines("input.txt", "\n\n", chomp: true)

sum_of_counts = groups.sum { |group| group.split.map(&:chars).reduce(:&).count }

puts sum_of_counts
