CHOICES = { 'r' => 'rock', 's' => 'scissors', 'p' => 'paper' }
SYMBOLS = { 'r' => "\xe2\x9c\x8a",
            's' => "\xe2\x9c\x8c",
            'p' => "\xe2\x9c\x8b" }

def say_then_pause(message)
  puts message
  sleep 1
end

loop do
  opponent = "#{CHOICES.values.sample.capitalize} Head"

  puts "I am #{opponent}, henchman of the King!"
  say_then_pause 'I challenge you to a Janken match!'
  puts 'You must choose either rock (r), scissors (s) or paper (p)'

  player_choice = gets.chomp.downcase

  until CHOICES.include?(player_choice)
    puts 'Error - you must choose rock (r), scissors (s) or paper (p)'
    player_choice = gets.chomp
  end

  computer_choice = CHOICES.keys.sample
  sleep 1

  say_then_pause 'Saisho wa gu, janken pon!'
  say_then_pause "You throw #{CHOICES[player_choice]}  " \
                 "#{SYMBOLS[player_choice]}"
  say_then_pause "#{opponent} throws #{CHOICES[computer_choice]}  " \
                 "#{SYMBOLS[computer_choice]}"

  if player_choice == computer_choice
    say_then_pause "It's a draw!"

  elsif player_choice == 'r' && computer_choice == 's' ||
        player_choice == 's' && computer_choice == 'p' ||
        player_choice == 'p' && computer_choice == 'r'
    say_then_pause 'You win!'
  else
    say_then_pause "#{opponent} wins!"
  end

  puts 'Try again? (y/n)'
  break if gets.chomp.downcase != 'y'
end
