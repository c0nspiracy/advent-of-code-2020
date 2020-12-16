# frozen_string_literal: true

def parse_ticket(data)
  data.split(",").map(&:to_i)
end

def any_range_covers?(ranges, value)
  ranges.any? { |range| range.cover?(value) }
end

rule_input, my_ticket_input, ticket_input = File.readlines(ARGV.first, "\n\n", chomp: true)

rules = rule_input.each_line(chomp: true).each_with_object({}) do |rule, memo|
  matches = rule.match(/\A([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)\z/)

  memo[matches[1]] = [
    Range.new(matches[2].to_i, matches[3].to_i),
    Range.new(matches[4].to_i, matches[5].to_i)
  ]
end

my_ticket = parse_ticket(my_ticket_input.lines(chomp: true).last)

nearby_tickets = ticket_input.each_line(chomp: true).drop(1).map { |ticket| parse_ticket(ticket) }

valid_tickets = nearby_tickets.reject do |values|
  values.any? do |value|
    rules.values.none? { |ranges| any_range_covers?(ranges, value) }
  end
end

fields = valid_tickets.transpose.each_with_index.to_a.to_h(&:reverse)
departure_field_positions = []

loop do
  rules.delete_if do |name, ranges|
    matching_fields = fields.keys.select do |position|
      fields[position].all? { |value| any_range_covers?(ranges, value) }
    end

    next unless matching_fields.one?

    departure_field_positions.concat(matching_fields) if name.start_with?("departure")
    fields.delete(*matching_fields)

    true
  end

  break if departure_field_positions.size == 6
end

puts my_ticket.values_at(*departure_field_positions).reduce(:*)
