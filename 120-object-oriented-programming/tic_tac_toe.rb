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

  def []=(num, marker)
   @squares[num].marker = marker
  end

  def draw
    <<~HEREDOC
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

  def markers
    @squares.values.collect { |square| square.marker unless square.unmarked? }
  end

  def all_same_marker?(squares)
    squares.all?(&:marked?) && squares.collect(&:marker).uniq.count == 1
  end

  def winning_marker
    WINNING_LINES.each do |line|
      line_squares = @squares.values_at(*line)
      return line_squares.first.marker if all_same_marker?(line_squares)
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
  attr_accessor :marker, :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def match_winner?
    score == TTTMatch::FIRST_TO
  end
end

class Game
  attr_reader :board, :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
    @board = Board.new
    @next_turn = human
    @winner = nil
  end

  def play
    clear
    display_board

    loop do
      current_player_moves
      clear_screen_and_display_board
      break if board.someone_won? || board.full?
    end

    calculate_winner
    update_score
    display_result
  end

  private

  def current_player_moves
    if @next_turn == human
      human_moves
      @next_turn = computer
    else
      computer_moves
      @next_turn = human
    end
  end

  def human_moves
    puts "Choose a square from: #{joinor(board.unmarked_keys)}:"
    square = ''

    loop do
      square = gets.chomp.to_i
      break if (board.unmarked_keys).include?(square)
      puts 'Invalid inputs, please choose an empty square.'
    end

    board[square] = human.marker
  end

  def joinor(array, delimiter=', ', before_last='or')
    output = array.join(delimiter)
    output[-3..-2] = " #{before_last} " if array.size > 1
    output
  end

  def computer_moves
    square = board.unmarked_keys.sample
    board[square] = computer.marker
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
    You're #{human.marker}, Computer is #{computer.marker}
    Score: You #{human.score}, Computer #{computer.score}

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
  FIRST_TO = 5
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def initialize
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    display_welcome_message

    loop do
      Game.new(@human, @computer).play
      break if winner || !play_again?
      display_play_again_message
    end

    print_match_winner
    display_goodbye_message
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

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end
end


TTTMatch.new.play
