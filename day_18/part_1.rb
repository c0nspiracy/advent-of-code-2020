# frozen_string_literal: true

require "./parser"

homework = File.readlines(ARGV.first, chomp: true)
parser = Parser.new

sum = homework.sum { |line| parser.parse(line).call }
puts sum
