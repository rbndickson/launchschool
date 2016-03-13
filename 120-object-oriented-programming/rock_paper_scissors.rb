class Move
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class Player
  attr_accessor :move, :name, :rules, :score, :move_history

  def initialize
    @score = 0
    @move_history = []
  end

  def rpsls_rules?
    rules.count == 5
  end

  def move_name
    move.name
  end

  def won_game_against?(other_player)
    rules[move.name][:wins_against].include?(other_player.move_name)
  end

  def move_history_display
    output = move_history.inject('') { |str, move| str + move + ', ' }
    output[0..-3] + '.'
  end

  def match_winner?
    score == Match::FIRST_TO
  end

  def display_move_instructions
    if rpsls_rules?
      puts 'Please choose rock, paper, scissors, lizard or spock.'
    else
      puts 'Please choose rock, paper or scissors.'
    end
  end
end

class Human < Player
  def initialize
    super
    set_name
  end

  def choose
    choice = nil

    loop do
      display_move_instructions
      choice = gets.chomp
      break if rules.keys.include?(choice)
      puts 'Sorry, invalid choice.'
    end

    self.move = Move.new(choice)
  end

  private

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
end

class Computer < Player
  attr_accessor :move_weights

  def initialize
    super
  end

  def self.select(number)
    case number
    when '1' then Johnny5.new
    when '2' then WallE.new
    when '3' then R2d2.new
    end
  end

  def choose
    weighted_choices = move_weights.to_a.map { |e| [e[0]] * e[1] }.flatten
    self.move = Move.new(weighted_choices.sample)
  end

  def update_move_weights(human_move)
    unless move_weights.values.include?(0)
      rules[human_move.name][:loses_to].each do |move_name|
        move_weights[move_name] += 2
      end

      move_weights[human_move.name] -= 1

      rules[human_move.name][:wins_against].each do |move_name|
        move_weights[move_name] -= 1
      end
    end
  end
end

class Johnny5 < Computer
  def initialize
    super
    @name = 'Johnny 5'
  end

  def set_move_weights
    self.move_weights = { 'rock' => 10, 'paper' => 10, 'scissors' => 10 }
    move_weights.merge!('lizard' => 10, 'spock' => 10) if rpsls_rules?
  end
end

class WallE < Computer
  def initialize
    super
    @name = 'Wall-E'
  end

  def set_move_weights
    self.move_weights = { 'rock' => 0, 'paper' => 0, 'scissors' => 50 }
    move_weights.merge!('lizard' => 0, 'spock' => 0) if rpsls_rules?
  end
end

class R2d2 < Computer
  def initialize
    super
    @name = 'R2D2'
  end

  def set_move_weights
    self.move_weights = { 'rock' => 20, 'paper' => 5, 'scissors' => 5 }
    move_weights.merge!('lizard' => 15, 'spock' => 5) if rpsls_rules?
  end
end

class Game
  attr_accessor :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
    @winner = nil
  end

  def play
    human.choose
    computer.choose
    display_moves
    set_winner(human, computer)
    update_score
    update_move_histories
    computer.update_move_weights(human.move)
    display_winner
  end

  private

  def set_winner(human, computer)
    @winner = human if human.won_game_against?(computer)
    @winner = computer if computer.won_game_against?(human)
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
    @winner ? puts("#{@winner.name} won!") : puts("It's a tie!")
  end
end

class Match
  FIRST_TO = 3
  RPS_RULES = {
    'rock' =>     { wins_against: ['scissors'], loses_to: ['paper'] },
    'scissors' => { wins_against: ['paper'], loses_to: ['rock'] },
    'paper' =>    { wins_against: ['rock'], loses_to: ['scissors'] }
  }.freeze

  RPSLS_RULES = {
    'rock' => {
      wins_against: ['scissors', 'lizard'],
      loses_to: ['paper', 'spock']
    },
    'scissors' => {
      wins_against: ['paper', 'lizard'],
      loses_to: ['rock', 'spock']
    },
    'paper' => {
      wins_against: ['rock', 'spock'],
      loses_to: ['scissors', 'lizard']
    },
    'lizard' => {
      wins_against: ['paper', 'spock'],
      loses_to: ['rock', 'scissors']
    },
    'spock' => {
      wins_against: ['rock', 'scissors'],
      loses_to: ['paper', 'lizard']
    }
  }.freeze

  attr_accessor :human, :computer

  def initialize(human)
    @human = human
    @computer = select_computer
  end

  def play
    set_game_rules
    computer.set_move_weights
    display_match_rules

    until winner
      Game.new(human, computer).play
      display_score
    end

    display_winning_message
    display_move_histories
    reset_human_data
  end

  private

  def select_computer
    answer = nil

    loop do
      puts "Choose your opponent:\n1: Johnny 5\n2: Wall-E\n3: R2D2"
      answer = gets.chomp
      break if ['1', '2', '3'].include?(answer.downcase)
      puts 'Please enter 1, 2 or 3.'
    end

    Computer.select(answer)
  end

  def set_game_rules
    answer = nil

    loop do
      puts "Choose game type:\n1: Rock, scissors, paper\n2: Rock, scissors, paper, lizard, spock"
      answer = gets.chomp
      break if ['1', '2'].include?(answer.downcase)
      puts 'Please enter 1 or 2.'
    end

    if answer == '1'
      human.rules = RPS_RULES
      computer.rules = RPS_RULES
    else
      human.rules = RPSLS_RULES
      computer.rules = RPSLS_RULES
    end
  end

  def display_match_rules
    puts "The first player to win #{FIRST_TO} games is the winner!"
  end

  def display_score
    puts "#{human.name} #{human.score} - #{computer.score} #{computer.name}"
  end

  def winner
    [human, computer].find(&:match_winner?)
  end

  def display_winning_message
    puts "#{winner.name} has won the match!"
  end

  def display_move_histories
    puts "#{human.name} chose #{human.move_history_display}."
    puts "#{computer.name} chose #{computer.move_history_display}."
  end

  def reset_human_data
    human.score = 0
    human.move_history = []
  end
end

class RPS
  def initialize
    @human = Human.new
  end

  def start
    display_welcome_message

    loop do
      Match.new(@human).play
      break unless play_again?
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
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

  def display_goodbye_message
    puts 'Thank you for playing!'
  end
end

RPS.new.start
