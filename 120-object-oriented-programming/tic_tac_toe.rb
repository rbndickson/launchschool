class Array
  def joinor(delimiter=', ', before_last='or')
    output = self.join(delimiter)
    output[-3..-2] = " #{before_last} " if self.size > 1
    output
  end
end

module MenuDisplay
  def self.update(message, time=1)
    sleep time
    system 'clear'
    puts "#{message}"
  end
end

class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ]

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def [](num)
   @squares[num].marker
  end

  def []=(num, marker)
   @squares[num].marker = marker
  end

  def draw
    <<-HEREDOC
        #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}
      -----+-----+-----
        #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}
      -----+-----+-----
        #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}
    HEREDOC
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def center_empty?
    @squares[5] == Square::INITIAL_MARKER
  end

  def three_in_a_row?(squares)
    squares.all?(&:marked?) && squares.collect(&:marker).uniq.count == 1
  end

  def two_in_a_row?(squares, marker)
    squares.count { |square| square.marker == Square::INITIAL_MARKER} == 1 &&
    squares.count { |square| square.marker == marker} == 2
  end

  def empty_square_position(squares)
    empty_square = squares.find do |square|
      square.marker == Square::INITIAL_MARKER
    end

    @squares.key(empty_square)
  end

  def find_winning_space_for(marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return empty_square_position(squares) if two_in_a_row?(squares, marker)
    end

    nil
  end

  def winning_marker
    WINNING_LINES.each do |line|
      line_squares = @squares.values_at(*line)
      return line_squares.first.marker if three_in_a_row?(line_squares)
    end

    nil
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    marker
  end
end

class Player
  attr_accessor :name, :marker, :score

  def initialize
    @score = 0
  end

  def match_winner?
    score == TTTMatch::FIRST_TO
  end
end

class Human < Player
  include MenuDisplay

  attr_reader :marker

  def initialize
    super
    set_name
    set_marker
    @marker = marker
  end

  def set_name
    name = ''

    loop do
      MenuDisplay.update('Please enter your name:')
      name = gets.chomp
      break unless name.empty?
      puts 'You must enter a name.'
    end

    self.name = name
  end

  def set_marker
    marker = ''

    loop do
      MenuDisplay.update('Please enter a marker:')
      marker = gets.chomp
      break if marker.length == 1
      puts 'The marker must be 1 character long.'
    end

    self.marker = marker
  end

  def move(board)
    puts "Choose a square from #{board.unmarked_keys.joinor}:"
    square = ''

    loop do
      square = gets.chomp.to_i
      break if (board.unmarked_keys).include?(square)
      puts 'Invalid inputs, please choose an empty square.'
    end

    board[square] = marker
  end

  def display_menu(message)
    sleep 1
    system 'clear'
    puts "#{message}"
  end
end

class Computer < Player
  MARKER = 'O'

  attr_accessor :opponents_marker

  def initialize
    super
    set_name
    @marker = MARKER
    @opponents_marker = nil
  end

  def set_name
    self.name = ['Alice', 'Bob', 'Charlie'].sample
  end

  def move(board)
    if board.find_winning_space_for(marker)
      attack(board)
    elsif board.find_winning_space_for(opponents_marker)
      defend(board)
    elsif board.center_empty?
      choose_center_position(board)
    else
      choose_random_position(board)
    end
  end

  def attack(board)
    board[board.find_winning_space_for(marker)] = marker
  end

  def defend(board)
    board[board.find_winning_space_for(opponents_marker)] = marker
  end

  def choose_center_position(board)
    board[5] = marker
  end

  def choose_random_position(board)
    square = board.unmarked_keys.sample
    board[square] = marker
  end
end

class Game
  attr_reader :board, :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
    @board = Board.new
    @next_player = human
    @winner = nil
  end

  def play
    clear
    display_board

    until board.someone_won? || board.full?
      next_player_moves
      clear_screen_and_display_board
    end

    calculate_winner
    update_score
    display_result
  end

  private

  def next_player_moves
    if @next_player == human
      human.move(board)
      @next_player = computer
    else
      computer.move(board)
      @next_player = human
    end
  end

  def calculate_winner
    case board.winning_marker
    when human.marker then @winner = human
    when computer.marker then @winner = computer
    end
  end

  def update_score
    @winner.score += 1 if @winner
  end

  def display_result
    case @winner
    when human then puts 'You won!'
    when computer then puts 'Computer won!'
    else puts "It's a tie!"
    end
  end

  def clear
    system 'clear'
  end

  def interface
    <<~HEREDOC
    #{human.name.ljust(16)}#{human.marker}       #{human.score}
    #{computer.name.ljust(16)}#{computer.marker}       #{computer.score}


    #{board.draw}

    HEREDOC
  end

  def display_board
    puts interface
  end

  def clear_screen_and_display_board
    clear
    display_board
  end
end

class TTTMatch
  include MenuDisplay

  FIRST_TO = 5

  def initialize
    @human = Human.new
    @computer = Computer.new
    @computer.opponents_marker = @human.marker
  end

  def play
    display_welcome_message

    loop do
      Game.new(@human, @computer).play
      break if winner || !play_again?
    end

    print_match_winner
    print_goodbye_message
  end

  def winner
    [@human, @computer].find(&:match_winner?)
  end

  def print_match_winner
    if winner == @human
      puts 'You have won the match!'
    else
      puts 'The computer has won the match!'
    end
  end

  def play_again?
    answer = ''

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Please enter y or n."
    end

    answer == 'y'
  end

  def display_welcome_message
    MenuDisplay.update(
      <<~HEREDOC
      Welcome to Tic Tac Toe!
      The first to #{FIRST_TO} is the winner.
      HEREDOC
    )
  end

  def print_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end
end

TTTMatch.new.play
