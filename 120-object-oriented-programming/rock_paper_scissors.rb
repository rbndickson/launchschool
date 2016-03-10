class MoveCreator
  def initialize(move)
    @move = move
  end

  def create
    case @move
    when 'rock' then Rock.new
    when 'scissors' then Scissors.new
    when 'paper' then Paper.new
    end
  end
end

class Move
  RULES = {
    'rock' =>     { wins_against: 'scissors', loses_to: 'paper' },
    'scissors' => { wins_against: 'paper', loses_to: 'rock' },
    'paper' =>    { wins_against: 'rock', loses_to: 'scissors' }
  }.freeze

  attr_accessor :name

  def >(other_move)
    other_move.name == RULES[name][:wins_against]
  end

  def <(other_move)
    other_move.name == RULES[name][:loses_to]
  end
end

class Rock < Move
  def initialize
    @name = 'rock'
  end
end

class Scissors < Move
  def initialize
    @name = 'scissors'
  end
end

class Paper < Move
  def initialize
    @name = 'paper'
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def move_name
    move.name
  end

  def move_history_display
    output = move_history.inject('') { |str, move| str + move + ', '  }
    output[0..-3] + '.'
  end

  def match_winner?
    score == RPSMatch::FIRST_TO
  end
end

class Human < Player
  def set_name
    n = ''

    loop do
      puts "what's your name?"
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, you must enter a name'
    end

    self.name = n
  end

  def choose
    choice = nil

    loop do
      puts 'Please choose rock, paper or scissors.'
      choice = gets.chomp
      break if Move::RULES.keys.include?(choice)
      puts 'Sorry, invalid choice.'
    end

    self.move = MoveCreator.new(choice).create
  end
end

class Computer < Player
  def set_name
    self.name = ['Johnny 5', 'Wall-E', 'R2D2'].sample
  end

  def choose
    self.move = MoveCreator.new(Move::RULES.keys.sample).create
  end
end

class Game
  attr_reader :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
    @winner = nil
  end

  def play
    human.choose
    computer.choose
    display_moves
    @winner = calculate_winner
    update_score
    update_move_histories
    display_winner
  end

  def calculate_winner
    return human if human.move > computer.move
    return computer if human.move < computer.move
  end

  def display_moves
    puts "#{human.name} chose #{human.move_name}."
    puts "#{computer.name} chose #{computer.move_name}."
  end

  def update_score
    @winner.score += 1 if @winner
  end

  def update_move_histories
    [human, computer].each { |player| player.move_history << player.move.name }
  end

  def display_winner
    if @winner
      puts "#{@winner.name} won!"
    else
      puts "It's a tie!"
    end
  end
end

class RPSMatch
  FIRST_TO = 3.freeze

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors'
    puts "The first player to #{FIRST_TO} is the winner!"
  end

  def display_goodbye_message
    puts 'Thank you for playing!'
  end

  def display_score
    puts "#{human.name} #{human.score} - #{computer.score} #{computer.name}"
  end

  def winner
    [human, computer].select { |player| player.match_winner? }.first
  end

  def display_winning_message
    puts "#{winner.name} has won the match!"
  end

  def display_move_histories
    puts "#{human.name} chose #{human.move_history_display}"
    puts "#{computer.name} chose #{computer.move_history_display}"
  end

  def reset_scores
    [human, computer].each { |player| player.score = 0 }
  end

  def play_again?
    answer = nil

    loop do
      puts 'Would you like to play again?'
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts 'Please enter y for yes or n for no.'
    end

    answer == 'y'
  end

  def play
    display_welcome_message

    loop do
      Game.new(human, computer).play
      display_score
      if winner
        display_winning_message
        display_move_histories
        reset_scores
        break unless play_again?
      end
    end

    display_goodbye_message
  end
end

RPSMatch.new.play
