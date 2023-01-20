# frozen_string_literal: true

cups = ARGV.first.chars.map(&:to_i)

current_cup = cups.first

100.times do
  pick_up_index = cups.index(current_cup) + 1

  pick_up = if pick_up_index <= cups.size - 3
              cups[pick_up_index, 3]
            else
              cups[pick_up_index..] + cups[0, 3 - (cups.size - pick_up_index)]
            end

  destination = ((current_cup - 2) % cups.length - 1) + 2
  destination = ((destination - 2) % cups.length - 1) + 2 while pick_up.include?(destination)

  other_cups = cups - pick_up
  dest_index = other_cups.index(destination) + 1
  cups = other_cups.insert(dest_index, *pick_up)

  current_cup = cups[(cups.index(current_cup) + 1) % cups.length]
end

final_index = (cups.index(1) + 1) % cups.size
final = if final_index.zero?
          cups
        else
          cups[final_index..] + cups[0, cups.size - (cups.size - final_index)]
        end
puts (final - [1]).join
