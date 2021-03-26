# rubocop:disable Layout/TrailingWhitespace
# TODO:

# Computer personalities
=begin
  Concepts:
    Rocky
    plays the counter to your last move (requires history)
    RPS_bot (random every time)
    Cycles through the moves
    Edward: highly favor S moves
  
  Structure:
    note: unique choose_move behavior based on...Name?
    subclass from Computer
    handle within the computer class

=end

# rubocop:enable Layout/TrailingWhitespace
require 'pry'

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
  attr_reader :name, :score

  def initialize
    reset
  end

  def reset
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
  def choose_name # too many lines 16/10
    input = ''
    loop do
      print 'Please enter player name: '
      input = gets.chomp
      if input.empty?
        puts 'Sorry, no input was recognized.'
      elsif input.length > 8
        puts 'Sorry max of 8 character name.'
      elsif input.match?(/\W/)
        puts 'Sorry, name can only contain letters, numbers, or underscore'
      else
        break
      end
    end
    @name = input
  end

  def choose_move
    input = ''
    loop do
      print 'Choose move: '
      input = gets.chomp.capitalize
      break if Moves.names.include?(input)
      puts "Invalid move selected, try: #{Moves.names.join(' | ')}"
    end
    Moves.create(input)
  end

  private

  def validate_name(name)
    # less than 8
    # must be word characters
    # can't be empty string
  end
end

class Computer < Player
  def choose_name
    @name = ['Hal', 'R2D2', 'C3P0', 'SkyNet', 'rps_bot'].sample
  end

  def choose_move
    move_name = Moves.names.sample
    Moves.create(move_name)
  end
  ##### pearsonalities #####
end

class RPSGame
  attr_reader :best_of_number, :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    computer.choose_name
    @history = History.new(human, computer)
    @best_of_number = 3
    @expansion = false
  end

  def menu # too many lines 18/10 , too many branches 21
    # choose opponent?
    puts welcome
    human.choose_name
    loop do
      puts '-------- Main Menu --------'
      puts 'Options: (play) (rounds) (expansion) (history) (quit)'
      case gets.chomp.downcase
      when 'play'      then play
      when 'rounds'    then ask_for_best_of_number
      when 'expansion' then choose_expansion
      when 'history'   then history.display
      when 'quit'      then break
      else puts 'Input not recognized, try again...'
      end
      print '<Enter> to return to menu >'
      gets
      system('clear')
    end
    puts goodbye
  end

  def play # too many lines 12/10
    round_number = 1
    human.reset
    computer.reset
    loop do
      current_round = Round.new(round_number, human, computer)
      current_round.play
      history.add_round(current_round)
      break unless winning_player.nil?
      round_number += 1
    end
    puts "!!!! #{winning_player} WINS THE SERIES  !!!!"
    history.add_series
  end

  def use_expansion?
    @expansion
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

  def goodbye
    [
      "",
      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
      "~~~~~~~ THANKS FOR PLAYING GOODBYE ~~~~~~",
      "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
      ""
    ]
  end

  def choose_expansion
    loop do
      verb = Moves.use_expansion? ? "Remove" : "Add"
      print "#{verb} Lizard Spock expansion? (yes/no) > "
      input = gets.chomp.downcase
      Moves.toggle_expansion if input == 'yes'
      break if input.match?(/\A(yes|no)/)
      puts "Input unrecognized please enter yes or no"
    end
  end

  def ask_for_best_of_number
    number = 0
    loop do
      puts 'Play to best of how many rounds?'
      number = gets.to_i
      break if number.odd? && number.positive?
      puts 'Sorry bad input. Must be a positive odd integer.'
    end
    @best_of_number = number
  end

  def score_to_win
    ((best_of_number + 1) / 2)
  end

  def toggle_expansion
    @expansion = !@expansion
  end
end

class History
  def initialize(human, computer)
    @human = human
    @computer = computer
    @series = []
    @rounds = []
  end

  def add_round(round)
    @rounds << round.to_s
  end

  def human
    @human.to_s
  end

  def computer
    @computer.to_s
  end

  def add_series
    @series << { human: human, computer: computer, rounds: @rounds }
    @rounds = []
  end

  def display
    puts "########## Game History ##########"
    @series.each_with_index do |game, index|
      puts "_________ Game ##{index + 1} ______________"
      puts format('__ %<human>-8s | %<computer>-8s __Score__', game)
      puts '--------------------------------'
      puts game[:rounds]
      puts
    end
  end
end

class Round
  attr_reader :round_number, :results
  attr_reader :human, :human_move, :computer, :computer_move

  def initialize(round_number, human, computer)
    @round_number = round_number
    @human = human
    @computer = computer
    @human_move = nil
    @computer_move = nil
  end

  def play
    puts "/////// ROUND ##{round_number} READY FIGHT! \\\\\\\\\\\\\\"
    @human_move = human.choose_move
    @computer_move = computer.choose_move
    puts '             ><-><->< '
    puts "             #{computer_move}"
    declare_winner
    save_results
    puts
  end

  def to_s
    template = '%<h_move>-8s | %<c_move>-8s [ %<h_score>d | %<c_score>d ]'
    "#{round_number}: " + format(template, results)
  end

  private

  def declare_winner
    if human_move == computer_move
      puts '==== draw ===== draw ==== draw ===='
    else
      winner.add_score
      scroll "#{arrow} #{winning_move} #{verb} #{losing_move} #{arrow}"
      puts "#{winner} wins the round!    #{scores}"
    end
  end

  def winning_move
    [human_move, computer_move].max
  end

  def losing_move
    [human_move, computer_move].min
  end

  def winner
    return human if winning_move == human_move
    computer
  end

  def verb
    winning_move.victory_verb(losing_move)
  end

  def arrow
    return "<<<<<<<<<<" if winner == human
    ">>>>>>>>>>"
  end

  def scroll(message)
    "#{message}\n".each_char do |char|
      print char
      sleep(0.03)
    end
  end

  def scores
    "{ #{human}: #{human.score} #{computer}: #{computer.score} }"
  end

  def save_results
    @results = { h_move: human_move.to_s,
                 c_move: computer_move.to_s,
                 h_score: human.score,
                 c_score: computer.score }
  end
end

game = RPSGame.new
game.menu
game.history.display
