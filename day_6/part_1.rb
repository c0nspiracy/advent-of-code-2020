# frozen_string_literal: true

groups = File.readlines("input.txt", "\n\n", chomp: true)

sum_of_counts = groups.sum { |group| group.split.flat_map(&:chars).uniq.count }

puts sum_of_counts
