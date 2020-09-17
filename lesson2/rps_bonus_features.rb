# TODO:
# => Keep track of move history
# => Computer personalities

class Player
  attr_accessor :name, :score, :move

  def initialize
    self.name = choose_name
    self.score = 0
  end

  def choose_name
    raise NoMethodError.new("#{self.class} failed to define choose_name")
  end

  def to_s
    name.to_s
  end
  # move history?
end

class Human < Player 
  def choose_name
    input = ''
    loop do
      puts 'Please enter player name:'
      input = gets.chomp
      break unless input.empty?
      puts 'Sorry, no input was recognized.'
    end
    input
  end

  def choose_move
    input = ''
    valid_moves = %w(Rock Paper Scissors).zip([Rock, Paper, Scissors]).to_h
    loop do
      puts 'Choose move:'
      input = gets.chomp.capitalize
      break if valid_moves.key?(input) #################### make a Move method
      puts 'Invalid move selected, choose again'
    end
    self.move = valid_moves[input].new #################################### Move method
  end
end

class Computer < Player
  def choose_name
    ['Hal', 'R2D2', 'C3P0', 'SkyNet'].sample
  end

  def choose_move
    self.move = [Rock, Paper, Scissors].sample.new ####################### Move method?
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

class RPSGame
  attr_accessor :number_of_rounds, :human, :computer

  # move history?
  def initialize
    puts '## WELCOME TO ROCK PAPER SCISSORS GAME ##'
    self.human = Human.new       ########## This should stay?
    self.computer = Computer.new ########## Move to RPSGame#play
    get_number_of_rounds       ############ Better name => move to #play
  end

  def play
    loop do
      round = 1
    # choose lizard spock expansion?
    # choose opponent?
    # choose number of rounds
      loop do
        # iterate through rounds until one player has a winning score
        computer.choose_move
        human.choose_move
        puts "#{human} chose #{human.move} and #{computer} chose #{computer.move}"
        if human.move == computer.move
          puts 'This round is a draw.'
          next
        end
        winner = human.move.beats?(computer.move) ? human : computer
        winner.score += 1
        puts "#{winner} wins the round with a score of #{winner.score}"
        round += 1
        break if human.score >= ((number_of_rounds + 1) / 2)
        break if computer.score >= ((number_of_rounds + 1) / 2)
      end
      overall_winner = human.score > computer.score ? human : computer
      puts "#{overall_winner} wins the entire game with a score of #{overall_winner.score}"
      break unless play_again? ########### scores need to be reset
    end
    puts '~~ THANKS FOR PLAYING GOODBYE ~~'
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

  def get_number_of_rounds # better name
    number = 0
    loop do
      puts 'Play to best of how many rounds?'
      number = gets.chomp.to_i
      break if number.odd?
      puts 'Sorry bad input. Must be an odd number'
    end
    self.number_of_rounds = number
  end
end

class Round # < RPS_game? either a collaborator or a subclass
  attr_reader :round_number

  def initialize(round_number)
    @round_number = round_number
  end
  # dramatic intro
  # each player chooses moves
  # compare moves
  # declare winnner
  # update player score
end

RPSGame.new.play
