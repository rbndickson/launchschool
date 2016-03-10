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
  attr_accessor :move, :name

  def initialize
    set_name
  end

  def move_name
    move.name
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

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
  end

  def display_goodbye_message
    puts 'Thank you for playing!'
  end

  def display_moves
    puts "#{human.name} chose #{human.move_name}."
    puts "#{computer.name} chose #{computer.move_name}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
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
      human.choose
      computer.choose
      display_moves
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
