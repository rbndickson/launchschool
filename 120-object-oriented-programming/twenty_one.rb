module Display
  def self.menu(message)
    system 'clear'
    puts "#{message}"
  end

  def self.title(message)
    menu(message)
    sleep 1
  end
end

class Participant
  attr_accessor :cards, :name

  def busted?
    card_total > Game::BLACKJACK_AMOUNT
  end

  def card_total
    total = @cards.reduce(0) { |sum, card| sum + card.score }
    number_of_aces.times { total -= 10 if total > Game::BLACKJACK_AMOUNT }
    total
  end

  private

  def number_of_aces
    @cards.count { |card| card.rank == 'A' }
  end
end

class Player < Participant
  def initialize
    @cards = []
    set_name
  end

  def hit?
    hit_or_stick? == 'h'
  end

  def hit_or_stick?
    answer = ''

    loop do
      puts "Will you hit or stay?"
      answer = gets.chomp.downcase
      break if ['hit', 'stick', 'h', 's'].include?(answer)
      puts "Please enter h for hit or s for stay."
    end

    answer[0]
  end

  private

  def set_name
    name = ''

    loop do
      Display.menu('Please enter your name:')
      name = gets.chomp
      break unless name.empty?
      puts 'Sorry, you must enter a name.'
    end

    self.name = name
  end
end

class Dealer < Participant
  NAME = 'Dealer'.freeze
  MINIMUM_STAY = 17

  def initialize
    @cards = []
    @name = NAME
  end
end

class Deck
  SUITS = [
    "\xe2\x99\xa0",
    "\xe2\x99\xa5",
    "\xe2\x99\xa3",
    "\xe2\x99\xa6"
  ].freeze
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K).freeze

  attr_accessor :cards

  def initialize
    @cards = create_cards.shuffle
  end

  private

  def create_cards
    SUITS.product(RANKS).inject([]) { |sum, values| sum << Card.new(values) }
  end
end

class Card
  PICTURE_CARDS = ['J', 'Q', 'K'].freeze

  attr_reader :suit, :rank

  def initialize(card_values)
    @suit = card_values[0]
    @rank = card_values[1]
  end

  def to_s
    @rank + @suit
  end

  def score
    if picture_card?
      10
    elsif ace?
      11
    else
      rank.to_i
    end
  end

  def picture_card?
    PICTURE_CARDS.include?(rank)
  end

  def ace?
    rank == 'A'
  end
end

class Game
  BLACKJACK_AMOUNT = 21
  FACE_DOWN_CARD = '**'
  HIDDEN_CARD_TOTAL = '?'

  attr_reader :deck, :player, :dealer

  def initialize(player)
    @deck = Deck.new
    @player = player
    @dealer = Dealer.new
    @dealers_card_hidden = true
  end

  def play
    initial_deal
    display
    player_turn
    flip_dealers_card
    dealer_turn unless player.busted?
    show_result
    reset_player_hand
  end

  private

  def initial_deal
    2.times do
      deal(player)
      deal(dealer)
    end
  end

  def deal(participant)
    participant.cards << deck.cards.pop
  end

  def display
    sleep 0.8
    system 'clear'
    puts interface
  end

  def interface
    <<~HEREDOC
     ----------------------------------------
    |#{dealers_card_total}|
    |#{name(dealer)}|
    |                                        |
    |                 #{dealers_cards}|
    |                                        |
    |                                        |
    |                 #{players_cards}|
    |                                        |
    |#{name(player)}|
    |#{players_card_total}|
     ----------------------------------------
    HEREDOC
  end

  def dealers_card_total
    if @dealers_card_hidden
      HIDDEN_CARD_TOTAL.center(40)
    else
      dealer.card_total.to_s.center(40)
    end
  end

  def players_card_total
    player.card_total.to_s.center(40)
  end

  def name(participant)
    participant.name.center(40)
  end

  def dealers_cards
    if @dealers_card_hidden
      cards = [FACE_DOWN_CARD, dealer.cards.last]
    else
      cards = dealer.cards
    end

    cards.join('  ').ljust(23)
  end

  def players_cards
    player.cards.join('  ').ljust(23)
  end

  def flip_dealers_card
    @dealers_card_hidden = false
    display
  end

  def player_turn
    while player.card_total < BLACKJACK_AMOUNT && player.hit?
      deal(player)
      display
    end
  end

  def dealer_turn
    while dealer.card_total < Dealer::MINIMUM_STAY
      deal(dealer)
      display
    end
  end

  def show_result
    puts "You busted!" if player.busted?
    puts "#{dealer.name} busted!" if dealer.busted?
    if winner
      puts "#{winner.name} is the winner!"
    else
      puts "It's a push!"
    end
  end

  def winner
    if player.busted?
      dealer
    elsif dealer.busted?
      player
    elsif player.card_total > dealer.card_total
      player
    elsif player.card_total < dealer.card_total
      dealer
    else
      nil
    end
  end

  def reset_player_hand
    @player.cards = []
  end
end

class TwentyOne
  def initialize
    @player = Player.new
  end

  def start
    display_welcome_message

    loop do
      Game.new(@player).play
      break unless play_again?
    end

    display_goodbye_message
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
    Display.title('Welcome to Twenty One!')
  end

  def display_goodbye_message
    puts 'Thanks for playing Twenty One! Goodbye!'
  end
end

TwentyOne.new.start
