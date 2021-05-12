require 'pry'

module Moves
  @@expansion = false

  def make(move_name)
    Moves.const_get(move_name).new
  end

  def use_expansion?
    @@expansion
  end

  def available_moves
    %w(Rock Paper Scissors) + (@@expansion ? %w(Lizard Spock) : [])
  end

  def toggle_expansion
    @@expansion = !@@expansion
  end

  def abbrieviations
    %w(R P S) + (@@expansion ? %w(L V) : [])
  end

  def full_name(letter)
    abbrieviations.zip(available_moves).to_h[letter]
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
  include Moves
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
  def choose_name # too many lines 13/10
    input = ''
    loop do
      prompt 'Please enter player name'
      input = gets.chomp
      if input.empty?
        puts 'Sorry, no input was recognized.'
      elsif input.length > 8
        puts 'Sorry, name must be 8 characters or fewer.'
      else
        break
      end
    end
    @name = input
  end

  def choose_move # too many lines 11
    input = ''
    loop do
      prompt 'Choose move'
      input = gets.chomp.capitalize
      input = full_name(input) if abbrieviations.include?(input)
      break if available_moves.include?(input)
      puts "Invalid move selected, try: #{available_moves.join(' | ')}"
      print "first letter also works"
      puts(use_expansion? ? " (use V for Spock)" : '')
    end
    make input
  end
end

class Computer < Player
  def choose_name
    @name = ['Hal', 'R2D2', 'C3P0', 'SkyNet', 'rps_bot'].sample
  end

  def choose_move
    make(available_moves.sample)
  end
end

module Display
  def prompt(message='')
    print "#{message} > "
  end

  def scroll(message)
    "#{message}\n".each_char do |char|
      print char
      sleep(0.03)
    end
  end

  def wait_for_user
    prompt '<Enter> to continue'
    gets
    clear
  end

  def clear
    system('clear')
  end
end

class RPSGame
  include Display
  EXPANSION = false
  SCORE_TO_WIN = 2
  MAX_SCORE_TO_WIN = 9 # history formating not set up for double digits
  attr_reader :score_to_win, :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    computer.toggle_expansion if EXPANSION
    @history = History.new
    @score_to_win = SCORE_TO_WIN
  end

  def start
    puts welcome
    human.choose_name
    computer.choose_name
    clear
    menu
  end

  private

  def menu # too many lines 15/10
    loop do
      puts '--------------------- Main Menu --------------------'
      puts 'Options: (play) (score) (expansion) (history) (quit)'
      prompt
      case gets.chomp.downcase
      when 'play'      then play
      when 'score'     then choose_score_to_win
      when 'expansion' then choose_expansion
      when 'history'   then history.display
      when 'quit'      then break
      else puts 'Input not recognized, try again...'
      end
      wait_for_user
    end
    puts goodbye
  end

  def play # too many lines 12/10, too many branches 18
    show_series_introduction
    round_number = 1
    human.reset
    computer.reset
    while winning_player.nil?
      current_round = Round.new(round_number, human, computer)
      current_round.play
      history.add_round(current_round)
      round_number += 1
    end
    declare_series_winner
    history.add_series(human, computer)
  end

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

  def show_series_introduction
    scroll "#{human} versus #{computer} "
    scroll "win #{score_to_win} rounds to take the series"
    wait_for_user
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

  def declare_series_winner
    scroll "!!!! #{winning_player} WINS THE SERIES  !!!!"
  end

  def choose_expansion
    loop do
      verb = human.use_expansion? ? "Remove" : "Add"
      prompt "#{verb} Lizard Spock expansion? (yes/no)"
      input = gets.chomp.downcase
      computer.toggle_expansion if input == 'yes'
      break if input.match?(/\A(yes|no)/)
      puts "Input unrecognized please enter yes or no"
    end
  end

  def choose_score_to_win # Too many lines 13/10
    number = 0
    loop do
      prompt 'Score how many points to win a series?'
      number = gets.to_i
      if number > MAX_SCORE_TO_WIN
        puts "That score is too high. " \
             "Choose a number less than #{MAX_SCORE_TO_WIN + 1}"
        next
      end
      break if number.positive?
      puts 'Sorry bad input. Must be a positive integer.'
    end
    @score_to_win = number
  end
end

class History
  def initialize
    @series = []
    @rounds = []
  end

  def add_round(round)
    template = '%<number>-2d: ' \
               '%<human_move>-8s | %<computer_move>-8s ' \
               '[ %<human_score>d | %<computer_score>d ]'
    @rounds << format(template, round.results)
  end

  def add_series(human, computer)
    @series << { human: human.to_s, computer: computer.to_s, rounds: @rounds }
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
  include Display
  attr_reader :number, :human, :human_move, :computer, :computer_move

  def initialize(number, human, computer)
    @number = number
    @human = human
    @computer = computer
    @human_move = nil
    @computer_move = nil
  end

  def play
    puts "/////// ROUND ##{number} READY FIGHT! \\\\\\\\\\\\\\"
    @human_move = human.choose_move
    @computer_move = computer.choose_move
    puts '             ><-><->< '
    puts "             #{computer_move}"
    declare_winner
    puts
  end

  def results
    {
      number: number,
      human: human.to_s,
      computer: computer.to_s,
      computer_move: computer_move.to_s,
      human_move: human_move.to_s,
      human_score: human.score,
      computer_score: computer.score
    }
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
    wait_for_user
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

  def scores
    "{ #{human}: #{human.score} #{computer}: #{computer.score} }"
  end
end

game = RPSGame.new
game.start
game.history.display
