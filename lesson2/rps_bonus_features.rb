# TODO:
# => Keep track of move history
# => Computer personalities

class Player
  attr_accessor :name, :score, :move

  def initialize
    self.name = choose_name
    self.score = 0
  end

  def reset
    self.move = nil
    self.score = 0
  end

  def to_s
    name.to_s
  end
end

class Human < Player
  def choose_name # too many lines
    input = ''
    loop do
      puts 'Please enter player name:'
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
    valid_moves = %w(Rock Paper Scissors).zip([Rock, Paper, Scissors]).to_h #### Move method
    loop do
      puts 'Choose move:'
      input = gets.chomp.capitalize
      break if valid_moves.key?(input) #################### make a Move method
      puts 'Invalid move selected, choose again'
    end
    self.move = valid_moves[input].new ############################# Move method
  end
end

class Computer < Player
  def choose_name
    ['Hal', 'R2D2', 'C3P0', 'SkyNet', 'rps_bot'].sample
  end

  def choose_move
    self.move = [Rock, Paper, Scissors].sample.new ################ Move method?
  end
  ##### pearsonalities #####
end

class Move
  def beats?(other_move)
    lesser_moves.include?(other_move.to_s)
  end

  def ==(other_move)
    self.class == other_move.class
  end

  def to_s
    self.class.to_s
  end
end

class Rock < Move
  def lesser_moves
    %w(Scissors Lizard)
  end
end

class Paper < Move
  def lesser_moves
    %w(Rock Spock)
  end
end

class Scissors < Move
  def lesser_moves
    %w(Paper Lizard)
  end
end

class Lizard < Move
  def lesser_moves
    %w(Paper Spock)
  end
end

class Spock < Move
  def lesser_moves
    %(Rock Scissors)
  end
end

class RPSGame # add method for setting history
  attr_accessor :best_of_number, :human, :computer, :history

  def initialize
    puts '## WELCOME TO ROCK PAPER SCISSORS GAME ##'
    self.human = Human.new
    self.computer = Computer.new ########## Move to RPSGame#play
    self.history = [{ human: human.to_s, computer: computer.to_s, rounds: [] }]
  end

  def play # too many lines, too many branches
    loop do
      round_number = 1
    # choose lizard spock expansion?
    # choose opponent?
      self.best_of_number = ask_for_best_of_number
      human.reset
      computer.reset
      loop do
        current_round = Round.new(round_number, human, computer)
        current_round.play
        history.last[:rounds] << current_round
        round_number += 1
        break if human.score >= score_to_win || computer.score >= score_to_win
      end
      overall_winner = human.score > computer.score ? human : computer
      puts "#{overall_winner} wins the series with a score of \
            #{overall_winner.score}"
      break unless play_again?
      history << { human: human.to_s, computer: computer.to_s, rounds: [] }
    end
    puts '~~~~~~ THANKS FOR PLAYING GOODBYE ~~~~~~~'
    display_history
  end

  def display_history
    history.each_with_index do |game, index|
      puts "_________ Game ##{index + 1} ______________"
      puts format('__ %<human>-8s | %<computer>-8s __Score__', game)
      puts '--------------------------------'
      puts game[:rounds]
      puts
    end
  end

  private

  def play_again?
    input = ''
    loop do
      puts 'Play again? (y/n)'
      input = gets.chomp
      break if input.match?(/\A[YyNn]/)
      puts 'Sorry, input not recognized.'
    end
    input.downcase.start_with?('y')
  end

  def ask_for_best_of_number # too many lines
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
    number
  end

  def score_to_win
    ((best_of_number + 1) / 2)
  end
end

class Round # RPS_game collaborator
  attr_reader :round_number, :human, :computer, :results

  def initialize(round_number, human, computer)
    @round_number = round_number
    @human = human
    @computer = computer
    @results = {}
  end

  # dramatic intro i.e. 'R2D2 leads!', 'Final Round!', 'Game point for Hal'
  def play # to many lines, to many branches
    puts "ROUND ##{round_number} READY FIGHT!"
    computer.choose_move
    human.choose_move
    puts "#{human} chose #{human.move} and #{computer} chose #{computer.move}"
    if human.move == computer.move
      puts 'This round is a draw.'
      save_results
      return
    end
    winner = human.move.beats?(computer.move) ? human : computer
    winner.score += 1
    puts "#{winner} wins the round! \
          #{human}: #{human.score} #{computer}: #{computer.score}"
    save_results
  end

  def to_s
    template = '%<h_move>-8s | %<c_move>-8s [ %<h_score>d | %<c_score>d ]'
    "#{round_number}: " + format(template, results)
  end

  private

  def save_results # too many method calls (branches)
    results[:h_move] = human.move.to_s
    results[:c_move] = computer.move.to_s
    results[:h_score] = human.score.to_s
    results[:c_score] = computer.score.to_s
  end
end

RPSGame.new.play

=begin
Input handler
  request possible inputs -help => quit, rock ...
  allow quit
  allow exit series
  help?

Prompt

Human had input output
RPSGame
Round

=end
