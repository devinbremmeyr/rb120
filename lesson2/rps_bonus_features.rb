# rubocop:disable Layout/TrailingWhitespace
# TODO:

# Computer personalities
=begin
  Concepts:
    Rocky
    plays the counter to your last move
    RPS_bot (random every time)
    Cycles through the moves
    Edward: highly favor S moves
  
  Structure:
    subclass from Computer
    handle within the computer class

=end

# Input handler
# prompt

=begin
Input handler
  request options inputs -help => quit, rock ...
  allow quit
  allow exit series => **game menu**

Prompt
  Input:
    Human #choose_move #choose_name      (valid_move) (1 < name.length < 8)
    RPSGame #ask_for_best_of_number  (y/n) (< 17, odd, positive)
    
    Computer/Game #choose_computer
    # => quit, exit_series, help (only validation is check for these)
     effect (skip to goodbye) (break out of series loop) (list options inputs)
  
  Ouput:
    Human #choose_move #choose_name
    RPSGame #initialize #play #play_again? #ask_for_best_of_number 
      #display_history
    Round #play

=end

# rubocop:enable Layout/TrailingWhitespace
require 'pry'

# class InOut
#   attr_reader :message

#   def prompt(message)
#     puts "=> #{message}"
#   end

#   def input
#     print '> '
#     gets.chomp
#   end

#   def input_with_test(message, warning)
#     token = nil
#     loop do
#       prompt(message)
#       token = input
#       break if yield(token)
#       prompt(warning)
#     end
#     token
#   end
# end

module Moves
  @@expansion = false

  def self.create(move_string)
    {
      Rock: Rock,
      Paper: Paper,
      Scissors: Scissors,
      Lizard: Lizard,
      Spock: Spock
    }.fetch(move_string.to_sym).new
  end

  def self.use_expansion?
    @@expansion
  end

  def self.names
    %w(Rock Paper Scissors) + (@@expansion ? %w(Lizard Spock) : [])
  end

  def self.toggle_expansion
    @@expansion = !@@expansion
  end

  class Move
    include Comparable

    def <=>(other_move)
      return 0 if self.class == other_move.class
      return 1 if lesser_moves.include?(other_move.class)
      -1
    end

    def victory_verb(other_move)
      lesser_moves.index(other_move.class)
    end

    def to_s
      self.class.to_s.delete_prefix('Moves::')
    end
  end

  class Rock < Move
    def lesser_moves
      [Scissors, Lizard].freeze
    end

    def victory_verb(other_move)
      %w(blunts crushes)[super] if super
    end
  end

  class Paper < Move
    def lesser_moves
      [Rock, Spock].freeze
    end

    def victory_verb(other_move)
      %w(covers disproves)[super] if super
    end
  end

  class Scissors < Move
    def lesser_moves
      [Paper, Lizard].freeze
    end

    def victory_verb(other_move)
      %w(cuts decapitates)[super] if super
    end
  end

  class Lizard < Move
    def lesser_moves
      [Paper, Spock].freeze
    end

    def victory_verb(other_move)
      %w(eats poisons)[super] if super
    end
  end

  class Spock < Move
    def lesser_moves
      [Rock, Scissors].freeze
    end

    def victory_verb(other_move)
      %w(vaporizes smashes)[super] if super
    end
  end
end

class Player
  attr_reader :name, :move, :score

  def initialize
    @name = choose_name
    @score = 0
  end

  def reset
    @move = nil
    @score = 0
  end

  def add_score
    @score += 1
  end

  def to_s
    name
  end
end

class Human < Player
  def choose_name # too many lines 13/10
    input = ''
    loop do
      print 'Please enter player name: '
      input = gets.chomp
      if input.empty?
        puts 'Sorry, no input was recognized.'
      elsif input.length > 8
        puts 'Sorry max of 8 character name.'
      else
        break
      end
    end
    input
  end

  def choose_move
    input = ''
    loop do
      print 'Choose move: '
      input = gets.chomp.capitalize
      break if Moves.names.include?(input)
      puts "Invalid move selected, try: #{Moves.names.join(' | ')}"
    end
    @move = Moves.create(input)
  end
end

class Computer < Player
  def choose_name
    ['Hal', 'R2D2', 'C3P0', 'SkyNet', 'rps_bot'].sample
  end

  def choose_move
    move_name = Moves.names.sample
    @move = Moves.create(move_name)
    puts "#{self} plays #{move}"
  end
  ##### pearsonalities #####
end

class RPSGame
  attr_reader :best_of_number, :human, :computer, :history

  def initialize
    puts welcome
    @human = Human.new
    @best_of_number = 3
    @history = GameHistory.new
    history.human = human
    @computer = Computer.new # move to menu
    history.computer = computer # move to menu
  end

  def menu # too many lines 16/10
    # choose opponent?
    loop do
      puts '-------- Main Menu --------'
      puts 'Options: (rounds) (expansion) (play) (history) (quit)'
      case gets.chomp
      when 'expansion' then choose_expansion
      when 'rounds'    then ask_for_best_of_number
      when 'play'      then play
      when 'history'   then history.display
      when 'quit'      then break
      else puts 'Input not recognized, try again:'
      end
      print '<Enter> to return to menu'
      gets
      system('clear')
    end
    puts '~~~~~~ THANKS FOR PLAYING GOODBYE ~~~~~~~'
  end

  def play # too many lines 14/10
    round_number = 1
    human.reset
    computer.reset
    winner = nil
    loop do
      current_round = Round.new(round_number, human, computer)
      current_round.play
      history.add_round(current_round)
      winner = winning_player
      break if winner
      round_number += 1
    end
    puts "!!!! #{winner} WINS THE SERIES  !!!!"
    history.add_series
  end

  private

  def winning_player
    return human if human.score == score_to_win
    return computer if computer.score == score_to_win
    nil
  end

  def welcome
    [
      ('#' * 41),
      ('##' + ' ' * 37 + '##'),
      '## WELCOME TO ROCK PAPER SCISSORS GAME ##',
      ('##' + ' ' * 37 + '##'),
      ('#' * 41)
    ]
  end

  def choose_expansion
    loop do
      puts (Moves.use_expansion? ? "Remove" : "Add") +
           " Lizard Spock expansion? (yes/no)"
      input = gets.chomp.downcase
      Moves.toggle_expansion if input == 'yes'
      break if input.match?(/\A(yes|no)/)
      puts "Input unrecognized please enter yes or no"
    end
  end

  def ask_for_best_of_number # too many lines 12/10
    number = 0
    loop do
      puts 'Play to best of how many rounds?'
      number = gets.to_i
      if number > 17
        puts "You can't be serious, enter smaller number"
        next
      end
      break if number.odd? && number.positive?
      puts 'Sorry bad input. Must be a positive odd integer.'
    end
    @best_of_number = number
  end

  def score_to_win
    ((best_of_number + 1) / 2)
  end
end

class GameHistory
  attr_reader :human, :computer, :rounds, :series

  def initialize
    @series = []
    @rounds = []
  end

  def add_round(round)
    rounds << round.to_s
  end

  def human=(human)
    @human = human.to_s
  end

  def computer=(computer)
    @computer = computer.to_s
  end

  def add_series
    series << { human: human, computer: computer, rounds: rounds }
    @rounds = []
  end

  def display
    puts "########## Game History ##########"
    series.each_with_index do |game, index|
      puts "_________ Game ##{index + 1} ______________"
      puts format('__ %<human>-8s | %<computer>-8s __Score__', game)
      puts '--------------------------------'
      puts game[:rounds]
      puts
    end
  end
end

class Round
  attr_reader :round_number, :human, :computer, :results

  def initialize(round_number, human, computer)
    @round_number = round_number
    @human = human
    @computer = computer
  end

  # dramatic intro i.e. 'R2D2 leads!', 'Final Round!', 'Game point for Hal'
  def play # too many lines, too many branches(30)
    puts ">>>> ROUND ##{round_number} READY FIGHT! <<<<"
    human.choose_move
    print '             ><-><->< '
    computer.choose_move
    if human.move == computer.move
      puts '==== draw ===== draw ==== draw ===='
    else
      loser, winner = [human, computer].sort_by(&:move)
      winner.add_score
      puts "#{winner.move} #{winner.move.victory_verb(loser.move)} #{loser.move}"
      puts "#{winner} wins the round!           " \
           "{ #{human}: #{human.score} #{computer}: #{computer.score} }"
    end
    save_results
  end

  def to_s
    template = '%<h_move>-8s | %<c_move>-8s [ %<h_score>d | %<c_score>d ]'
    "#{round_number}: " + format(template, results)
  end

  private

  def save_results
    @results = { h_move: human.move.to_s,
                 c_move: computer.move.to_s,
                 h_score: human.score,
                 c_score: computer.score }
  end
end

game = RPSGame.new
game.menu
game.history.display
