# frozen_string_literal: true

lines = File.readlines("input.txt", chomp: true).map { |line| line.split(": ") }

valid_passwords = lines.count do |policy, password|
  match_data = policy.match(/\A(?<position_1>\d+)-(?<position_2>\d+) (?<letter>[a-z])\z/)
  indices = %i[position_1 position_2].map { |n| match_data[n].to_i - 1 }

  indices.one? { |index| password[index] == match_data[:letter] }
end

puts valid_passwords
