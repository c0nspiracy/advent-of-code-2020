# frozen_string_literal: true

require "./luggage_rules"

input = File.readlines("input.txt", chomp: true)
puts LuggageRules.new(input).bags_that_contain("shiny gold").uniq.length
