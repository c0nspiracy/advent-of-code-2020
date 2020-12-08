# frozen_string_literal: true

require "./game_console"

instructions = File.readlines("input.txt", chomp: true).map(&:split)

patches_to_try = instructions.map.with_index do |(operation, argument), address|
  case operation
  when "nop" then { address => ["jmp", argument] }
  when "jmp" then { address => ["nop", argument] }
  end
end.compact

game_console = GameConsole.new(instructions)

patches_to_try.each do |patches|
  game_console.run(patches)

  break if game_console.state == :terminated
end

puts game_console.accumulator
