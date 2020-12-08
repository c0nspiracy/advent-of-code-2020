# frozen_string_literal: true

require "./game_console"

instructions = File.readlines("input.txt", chomp: true).map(&:split)

game_console = GameConsole.new(instructions)
game_console.run

puts game_console.accumulator
