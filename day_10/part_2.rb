# frozen_string_literal: true

adapters = File.readlines(ARGV.first, chomp: true).map(&:to_i).sort

adapters.unshift(0)
adapters.push(adapters.last + 3)

gaps = adapters.each_with_object({}) do |adapter, memo|
  memo[adapter] = adapters.select { |other_adapter| (other_adapter - adapter).between?(1, 3) }
end

gaps[adapters.last] = 1
adapters.reverse[1..].each do |adapter|
  gaps[adapter] = gaps[adapter].sum { |other_adapter| gaps[other_adapter] }
end

puts gaps[0]
