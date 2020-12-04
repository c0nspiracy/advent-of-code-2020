# frozen_string_literal: true

VALIDATORS = {
  "byr" => ->(year)  { year.to_i.between?(1920, 2002) },
  "iyr" => ->(year)  { year.to_i.between?(2010, 2020) },
  "eyr" => ->(year)  { year.to_i.between?(2020, 2030) },
  "hcl" => ->(color) { color.match?(/\A#\h{6}\z/) },
  "ecl" => ->(color) { %w[amb blu brn gry grn hzl oth].include?(color) },
  "pid" => ->(pid)   { pid.match?(/\A\d{9}\z/) },
  "hgt" => lambda do |height|
    case height[-2, 2]
    when "cm" then height[0...-2].to_i.between?(150, 193)
    when "in" then height[0...-2].to_i.between?(59, 76)
    else false
    end
  end
}.freeze

data = File.readlines("input.txt", chomp: true).slice_after(/^$/)

passports = data.map do |lines|
  pairs = lines.flat_map { |line| line.split(" ") }
  pairs.map { |pair| pair.split(":") }.to_h
end

valid_passports = passports.count do |passport|
  VALIDATORS.all? { |field, validator| passport.key?(field) && validator.call(passport[field]) }
end

puts valid_passports
