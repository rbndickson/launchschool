module Display
  def self.update(message, time=2)
    sleep time
    system 'clear'
    puts "#{message}"
  end
end

class Move
  EMOJI = {
    'rock' => "\xe2\x9c\x8a",
    'scissors' => "\xe2\x9c\x8c\xef\xb8\x8f",
    'paper' => "\xe2\x9c\x8b",
    'lizard' => "\xf0\x9f\x90\x8d",
    'spock' => "\xf0\x9f\x96\x96"
  }.freeze

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def emoji
    EMOJI[name]
  end
end

class Player
  attr_accessor :move, :name, :rules, :score, :move_history, :avatar

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

  def hand
    move ? move.emoji : ''
  end

  def won_game_against?(other_player)
    rules[move.name][:wins_against].include?(other_player.move_name)
  end

  def move_history_emoji
    move_history.inject('') { |str, move| str + move.emoji + ' ' }
  end

  def match_winner?
    score == Match::FIRST_TO
  end
end

class Human < Player
  include Display

  AVATARS = {
    '1' => "\xf0\x9f\x98\x80",
    '2' => "\xf0\x9f\x98\x8e",
    '3' => "\xf0\x9f\x99\x83",
    '4' => "\xf0\x9f\x90\xb0",
    '5' => "\xf0\x9f\xa6\x84"
  }

  def initialize
    super
    set_name
    set_avatar
  end

  def choose
    choice = nil

    loop do
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
      Display.update("Please enter your name:")
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, you must enter a name'
    end

    self.name = n
  end

  def set_avatar
    n = ''

    loop do
      Display.update(
        "Please choose your avatar:\n" \
        "1: #{AVATARS['1']}\n" \
        "2: #{AVATARS['2']}\n" \
        "3: #{AVATARS['3']}\n" \
        "4: #{AVATARS['4']}\n" \
        "5: #{AVATARS['5']}\n",
        0
      )
      n = gets.chomp
      break if ('1'..'5').include?(n)
      puts 'Sorry, please choose a number 1 - 5'
    end

    self.avatar = AVATARS[n]
  end
end

class ComputerCreator
  def self.create(number)
    case number
    when '1' then TheMoon.new
    when '2' then WallE.new
    when '3' then Oni.new
    end
  end
end

class Computer < Player
  attr_accessor :move_weights

  def initialize
    super
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

class TheMoon < Computer
  def initialize
    super
    @name = 'The Moon'
    @avatar = "\xf0\x9f\x8c\x9d"
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
    @avatar = "\xf0\x9f\xa4\x96"
  end

  def set_move_weights
    self.move_weights = { 'rock' => 0, 'paper' => 0, 'scissors' => 50 }
    move_weights.merge!('lizard' => 0, 'spock' => 0) if rpsls_rules?
  end
end

class Oni < Computer
  def initialize
    super
    @name = 'Oni'
    @avatar = "\xf0\x9f\x91\xb9"
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
    clear_moves
    game_display([move_instructions])
    choose_moves
    game_display
    set_winner
    update_score
    update_move_histories
    computer.update_move_weights(human.move)
    game_display([winner_message])
  end

  private

  def players
    [human, computer]
  end

  def clear_moves
    players.each { |player| player.move = nil }
  end

  def choose_moves
    players.each(&:choose)
  end

  def move_instructions
    if human.rpsls_rules?
      'Please choose rock, paper, scissors, lizard or spock.'
    else
      'Please choose rock, paper or scissors.'
    end
  end

  def set_winner
    @winner = human if human.won_game_against?(computer)
    @winner = computer if computer.won_game_against?(human)
  end

  def update_score
    @winner.score += 1 if @winner
  end

  def update_move_histories
    players.each { |player| player.move_history << player.move }
  end

  def winner_message
    @winner ? "#{@winner.name} won!" : "It's a tie!"
  end

  def game_display(messages=[])
    sleep 1.5
    system 'clear'
    puts "#{computer.name} ".rjust(16) + "#{computer.score}" + ' - ' \
    "#{human.score}" + " #{human.name}".ljust(16)
    puts ''
    puts "#{computer.avatar}  #{computer.hand}".rjust(14) + '       ' \
    "#{human.hand}  #{human.avatar}".ljust(14)
    puts ''
    messages.each { |message| puts "#{message}".center(35) }
  end
end

class Match
  include Display

  FIRST_TO = 3
  RPS_RULES = {
    'rock'     => { wins_against: ['scissors'], loses_to: ['paper'] },
    'scissors' => { wins_against: ['paper'], loses_to: ['rock'] },
    'paper'    => { wins_against: ['rock'], loses_to: ['scissors'] }
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
    end

    display_match_finished_message
    reset_human_data
  end

  private

  def select_computer
    answer = nil

    loop do
      display_choose_opponent_text
      answer = gets.chomp
      break if ['1', '2', '3'].include?(answer)
      puts 'Please enter 1, 2 or 3.'
    end

    ComputerCreator.create(answer)
  end

  def set_game_rules
    answer = nil

    loop do
      display_choose_game_text
      answer = gets.chomp
      break if ['1', '2'].include?(answer)
      puts 'Please enter 1 or 2.'
    end

    if answer == '1'
      [human, computer].each { |x| x.rules = RPS_RULES }
    else
      [human, computer].each { |x| x.rules = RPSLS_RULES }
    end
  end

  def display_choose_opponent_text
    Display.update(
      "Choose your opponent:\n" \
      "1: #{TheMoon.new.avatar}  The Moon\n" \
      "2: #{WallE.new.avatar}  Wall-E\n" \
      "3: #{Oni.new.avatar}  Oni",
      0
    )
  end

  def display_choose_game_text
    Display.update(
      "Choose game type:\n" \
      "1: Rock, scissors, paper\n" \
      "2: Rock, scissors, paper, lizard, spock",
      0
    )
  end

  def display_match_rules
    Display.update("The first player to #{FIRST_TO} games is the winner!", 0)
  end

  def winner
    [human, computer].find(&:match_winner?)
  end

  def display_match_finished_message
    puts "#{winner.name} has won the match!\n\n"
    puts (human.name + ':').ljust(longest_name_length + 2) + human.move_history_emoji
    puts (computer.name + ':').ljust(longest_name_length + 2) + computer.move_history_emoji
  end

  def longest_name_length
    if human.name.length > computer.name.length
      human.name.length
    else
      computer.name.length
    end
  end

  def reset_human_data
    human.score = 0
    human.move_history = []
  end
end

class RPS
  include Display

  def initialize
    Display.update('Welcome to Rock, Paper, Scissors!', 0)
    @human = Human.new
  end

  def start
    loop do
      Match.new(@human).play
      break unless play_again?
    end

    display_goodbye_message
  end

  private

  def play_again?
    answer = nil

    loop do
      puts "\nWould you like to play again?"
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
