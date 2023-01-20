# frozen_string_literal: true

player_1, player_2 = ARGF.readlines("\n\n", chomp: true).map { |input| input.lines(chomp: true).drop(1).map(&:to_i) }

class Game
  attr_reader :player_1, :player_2

  def initialize(player_1, player_2)
    @player_1 = player_1
    @player_2 = player_2
    @round = 1
    @previous_rounds = []
  end

  def play
    play_round until winner_found?

    player_1.empty? ? 2 : 1
  end

  private

  attr_reader :round

  def play_round
    if previous_round_match?
      @player_2 = []
      return
    end
    @previous_rounds << [player_1, player_2].hash

    card_1 = player_1.shift
    card_2 = player_2.shift

    if player_1.size >= card_1 && player_2.size >= card_2
      sub_game_winner = Game.new(player_1.take(card_1).dup, player_2.take(card_2).dup).play

      if sub_game_winner == 1
        player_1.push card_1, card_2
      else
        player_2.push card_2, card_1
      end
    else
      case card_1 <=> card_2
      when 1
        player_1.push card_1, card_2
      when -1
        player_2.push card_2, card_1
      end
    end

    @round += 1
  end

  def winner_found?
    player_1.empty? || player_2.empty?
  end

  def previous_round_match?
    @previous_rounds.include?([player_1, player_2].hash)
  end
end

game = Game.new(player_1.dup, player_2.dup)
winner = game.play

winners_deck = winner == 1 ? game.player_1 : game.player_2

winning_score = winners_deck.reverse_each.with_index(1).sum { |card, index| card * index }
puts winning_score
