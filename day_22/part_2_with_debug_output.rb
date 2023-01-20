# frozen_string_literal: true

player_1, player_2 = ARGF.readlines("\n\n", chomp: true).map { |input| input.lines(chomp: true).drop(1).map(&:to_i) }

$game_id = 1

class Game
  attr_reader :player_1, :player_2

  def initialize(player_1, player_2)
    @player_1 = player_1
    @player_2 = player_2
    @game_id = $game_id
    @round = 1
    @previous_rounds = []
    $game_id += 1
  end

  def play
    play_round until winner_found?

    winner = player_1.empty? ? 2 : 1
    # puts "The winner of game #{game_id} is player #{winner}"
    winner
  end

  private

  attr_reader :game_id, :round

  def play_round
    # puts "\n-- Round #{round} (Game #{game_id}) --"
    # puts "Player 1's deck: #{player_1.join(', ')}"
    # puts "Player 2's deck: #{player_2.join(', ')}"

    if previous_round_match?
      # puts "Preventing infinite recursion!"
      @player_2 = []
      return
    end
    #@previous_rounds << { player_1: player_1.dup, player_2: player_2.dup }
    @previous_rounds << [player_1, player_2].hash

    card_1 = player_1.shift
    card_2 = player_2.shift

    # puts "Player 1 plays: #{card_1}"
    # puts "Player 2 plays: #{card_2}"

    # Sub game triggering
    if player_1.size >= card_1 && player_2.size >= card_2
      # puts "Playing a sub-game to determine the winner..."
      sub_game_winner = Game.new(player_1.take(card_1).dup, player_2.take(card_2).dup).play

      # puts "\n...anyway, back to game #{game_id}."
      if sub_game_winner == 1
        player_1.push card_1, card_2
        # puts "Player 1 wins round #{round} of game #{game_id}!"
      else
        player_2.push card_2, card_1
        # puts "Player 2 wins round #{round} of game #{game_id}!"
      end
    else
      case card_1 <=> card_2
      when 1
        player_1.push card_1, card_2
        # puts "Player 1 wins round #{round} of game #{game_id}!"
      when -1
        player_2.push card_2, card_1
        # puts "Player 2 wins round #{round} of game #{game_id}!"
      end
    end

    @round += 1
  end

  def winner_found?
    player_1.empty? || player_2.empty?
  end

  def previous_round_match?
    # @previous_rounds.any? { |d| d[:player_1] == player_1 && d[:player_2] == player_2 }
    @previous_rounds.include?([player_1, player_2].hash)
  end
end

game = Game.new(player_1.dup, player_2.dup)
winner = game.play

# puts
# puts "== Post-game results =="
# puts "Player 1's deck: #{game.player_1.join(', ')}"
# puts "Player 2's deck: #{game.player_2.join(', ')}"

winners_deck = winner == 1 ? game.player_1 : game.player_2

winning_score = winners_deck.reverse_each.with_index(1).sum { |card, index| card * index }
puts winning_score
