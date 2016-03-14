module MenuDisplay
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

  attr_reader :name, :emoji

  def initialize(name)
    @name = name
    @emoji = EMOJI[name]
  end
end

class Player
  attr_accessor :move, :name, :rules, :score, :move_history, :avatar

  def initialize
    @score = 0
    @move_history = []
  end

  def rps_rules?
    rules.count == 3
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
  include MenuDisplay

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
      MenuDisplay.update('Please enter your name:')
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, you must enter a name.'
    end

    self.name = n
  end

  def set_avatar
    n = ''

    loop do
      MenuDisplay.update(avatar_menu_text, 0)
      n = gets.chomp
      break if ('1'..'5').include?(n)
      puts 'Please choose a number 1 - 5.'
    end

    self.avatar = AVATARS[n]
  end

  def avatar_menu_text
    <<~HEREDOC
    Please choose your avatar:
    1: #{AVATARS['1']}
    2: #{AVATARS['2']}
    3: #{AVATARS['3']}
    4: #{AVATARS['4']}
    5: #{AVATARS['5']}
    HEREDOC
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
    move_weights.merge!('lizard' => 10, 'spock' => 10) unless rps_rules?
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
    move_weights.merge!('lizard' => 0, 'spock' => 0) unless rps_rules?
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
    move_weights.merge!('lizard' => 15, 'spock' => 5) unless rps_rules?
  end
end

class Game
  attr_accessor :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
    clear_moves
  end

  def play
    update_game_display(move_instructions)
    choose_moves
    update_game_display
    update_score
    update_move_histories
    computer.update_move_weights(human.move)
    update_game_display(game_result_message)
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
    basic = 'Please choose rock, scissors'
    human.rps_rules? ? basic + ' or paper.' : basic + ', paper, lizard or spock.'
  end

  def winner
    return human if human.won_game_against?(computer)
    return computer if computer.won_game_against?(human)
  end

  def update_score
    winner.score += 1 if winner
  end

  def update_move_histories
    players.each { |player| player.move_history << player.move }
  end

  def game_result_message
    winner ? "#{winner.name} won!" : "It's a tie!"
  end

  def update_game_display(message='')
    sleep 1.5
    system 'clear'
    puts game_display(message)
  end

  def game_display(message)
    <<~HEREDOC
      #{computer_display_title} - #{human_display_title}

      #{computer_character}       #{human_character}

      #{message.center(35)}
    HEREDOC
  end

  def computer_display_title
    "#{computer.name} #{computer.score}".rjust(16)
  end

  def human_display_title
    "#{human.score} #{human.name}".ljust(16)
  end

  def computer_character
    "#{computer.avatar}  #{computer.hand}".rjust(14)
  end

  def human_character
    "#{human.hand}  #{human.avatar}".ljust(14)
  end
end

class Match
  include MenuDisplay

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
    set_match_rules
    computer.set_move_weights
    display_match_rules

    until winner
      Game.new(human, computer).play
    end

    print_match_winner
    puts ''
    print_move_histories
    reset_human_data
  end

  private

  def select_computer
    answer = nil

    loop do
      MenuDisplay.update(choose_opponent_text, 0)
      answer = gets.chomp
      break if ['1', '2', '3'].include?(answer)
      puts 'Please enter 1, 2 or 3.'
    end

    ComputerCreator.create(answer)
  end

  def set_match_rules
    answer = nil

    loop do
      MenuDisplay.update(choose_rules_text, 0)
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

  def choose_opponent_text
    <<~HEREDOC
    Choose your opponent:
    1: #{TheMoon.new.avatar}  The Moon
    2: #{WallE.new.avatar}  Wall-E
    3: #{Oni.new.avatar}  Oni
    HEREDOC
  end

  def choose_rules_text
    <<~HEREDOC
    Choose game type:
    1: Rock, scissors, paper
    2: Rock, scissors, paper, lizard, spock
    HEREDOC
  end

  def display_match_rules
    MenuDisplay.update("The first player to #{FIRST_TO} games is the winner!", 0)
  end

  def winner
    [human, computer].find(&:match_winner?)
  end

  def print_match_winner
    puts "#{winner.name} has won the match!"
  end

  def print_move_histories
    puts move_history_name(human) + human.move_history_emoji
    puts move_history_name(computer) + computer.move_history_emoji
  end

  def move_history_name(player)
    (player.name + ':').ljust(longest_name_length + 2)
  end

  def longest_name_length
    [human.name, computer.name].max.length
  end

  def reset_human_data
    human.score = 0
    human.move_history = []
  end
end

class RPS
  def initialize
    MenuDisplay.update('Welcome to Rock, Paper, Scissors!', 0)
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
      puts ''
      puts "Would you like to play again?"
      answer = gets.chomp
      break if ['y', 'yes', 'n', 'no'].include?(answer.downcase)
      puts 'Please enter y for yes or n for no.'
    end

    answer == 'y' || answer == 'yes'
  end

  def display_goodbye_message
    puts 'Thank you for playing!'
  end
end

RPS.new.start
