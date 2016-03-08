class Move
  VALUES = ['rock', 'paper', 'scissors'].freeze
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    rock? && other_move.scissors? ||
      paper? && other_move.rock? ||
      scissors? && other_move.paper?
  end

  def <(other_move)
    rock? && other_move.paper? ||
      paper? && other_move.scissors? ||
      scissors? && other_move.rock?
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    @move = nil
    set_name
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
      break if Move::VALUES.include?(choice)
      puts 'Sorry, invalid choice.'
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Johnny 5', 'WallE', 'R2D2'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
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
    puts "#{human.name} chose #{human.move.value}."
    puts "#{computer.name} chose #{computer.move.value}."
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
