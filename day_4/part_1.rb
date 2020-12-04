# frozen_string_literal: true

REQUIRED_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze

data = File.readlines("input.txt", chomp: true).slice_after(/^$/)

passports = data.map do |lines|
  pairs = lines.flat_map { |line| line.split(" ") }
  pairs.map { |pair| pair.split(":") }.to_h
end

valid_passports = passports.count do |passport|
  REQUIRED_FIELDS.all? { |field| passport.key?(field) }
end

puts valid_passports
