# frozen_string_literal: true

class LuggageRules
  BAG_REGEXP = /(?<color>\w+\s\w+) bags?/.freeze

  def initialize(input)
    @rules = parse_rules(input)
  end

  def bags_that_contain(color)
    @rules.each_with_object([]) do |(bag, rules), memo|
      next unless rules.any? { |rule| rule["color"] == color }

      memo << bag
      memo.concat bags_that_contain(bag)
    end
  end

  def number_of_bags_inside(color)
    @rules[color].sum(1) do |rule|
      next 0 if rule.empty?

      rule["count"].to_i * number_of_bags_inside(rule["color"])
    end
  end

  private

  def parse_rules(input)
    input.each_with_object({}) do |line, memo|
      match_data = line.match(/\A#{BAG_REGEXP} contain (?<rules>.*).\z/)
      rules = match_data["rules"].split(", ")

      memo[match_data["color"]] = rules.map do |rule|
        next {} if rule == "no other bags"

        rule.match(/(?<count>\d+) #{BAG_REGEXP}/).named_captures
      end
    end
  end
end
