# frozen_string_literal: true

lines = File.readlines("input.txt", chomp: true).map { |line| line.split(": ") }

valid_passwords = lines.count do |policy, password|
  match_data = policy.match(/\A(?<min>\d+)-(?<max>\d+) (?<letter>[a-z])\z/)

  password.count(match_data[:letter]).between?(match_data[:min].to_i, match_data[:max].to_i)
end

puts valid_passwords
