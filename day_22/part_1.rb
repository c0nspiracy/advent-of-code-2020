# frozen_string_literal: true

player_1, player_2 = ARGF.readlines("\n\n", chomp: true).map { |input| input.lines(chomp: true).drop(1).map(&:to_i) }

puts player_1.inspect
puts player_2.inspect

round = 1
loop do
  break if player_1.empty? || player_2.empty?

  puts "-- Round #{round} --"
  puts "Player 1's deck: #{player_1.join(', ')}"
  puts "Player 2's deck: #{player_2.join(', ')}"

  card_1 = player_1.shift
  card_2 = player_2.shift
  puts "Player 1 plays: #{card_1}"
  puts "Player 2 plays: #{card_2}"

  case card_1 <=> card_2
  when 1
    player_1.push card_1, card_2
    puts "Player 1 wins the round!"
  when -1
    player_2.push card_2, card_1
    puts "Player 2 wins the round!"
  end

  round += 1
  puts
end

puts
puts "== Post-game results =="
puts "Player 1's deck: #{player_1.join(', ')}"
puts "Player 2's deck: #{player_2.join(', ')}"

winners_deck = player_1.empty? ? player_2 : player_1

winning_score = winners_deck.reverse_each.with_index(1).sum { |card, index| card * index }
puts winning_score
