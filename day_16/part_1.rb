# frozen_string_literal: true

rule_input, _, ticket_input = File.readlines(ARGV.first, "\n\n", chomp: true)

rules = rule_input.each_line.map do |rule|
  matches = rule.match(/[\w ]+: (\d+)-(\d+) or (\d+)-(\d+)/)

  [
    Range.new(matches[1].to_i, matches[2].to_i),
    Range.new(matches[3].to_i, matches[4].to_i)
  ]
end

tickets = ticket_input.each_line.drop(1).map do |ticket|
  ticket.split(",").map(&:to_i)
end

invalid_values = tickets.flatten.select do |value|
  rules.none? do |ranges|
    ranges.any? { |range| range.cover?(value) }
  end
end

puts invalid_values.sum
