# frozen_string_literal: true

require "./luggage_rules"

input = File.readlines("input.txt", chomp: true)
puts LuggageRules.new(input).number_of_bags_inside("shiny gold") - 1
