CHOICES = {
  r: 'rock',
  s: 'scissors',
  p: 'paper',
  l: 'lizard',
  sp: 'spock'
}

EMOJI = {
  r: "\xe2\x9c\x8a",
  s: "\xe2\x9c\x8c\xef\xb8\x8f",
  p: "\xe2\x9c\x8b",
  l: "\xf0\x9f\x90\x8d",
  sp: "\xf0\x9f\x96\x96"
}

OPPONENTS = ["\xf0\x9f\x91\xb9", "\xf0\x9f\xa4\x96", "\xf0\x9f\x91\xbd",
             	"\xf0\x9f\x8c\x9d", "\xf0\x9f\x90\xb0", "\xf0\x9f\x99\x83"]

WINNING_COMBINATIONS = {
 [:r, :s] => 'Rock crushes Scissors',
 [:r, :l] => 'Rock crushes Lizard',
 [:s, :p] => 'Scissors cut Paper',
 [:s, :l] => 'Scissors decapitate Lizard',
 [:p, :r] => 'Paper covers Rock',
 [:p, :sp] => 'Paper disproves Spock',
 [:l, :p] => 'Lizard eats Paper',
 [:l, :sp] => 'Lizard poisons Spock',
 [:sp, :r] => 'Spock vaporizes Rock',
 [:sp, :s] => 'Spock smashes Scissors'
}

def say(message)
  puts message
  sleep 1
end

def opponent_says(message, opponent)
  puts "#{opponent} : #{message}"
  sleep 1
end

def calculate_result(player_choice, opponent_choice)
  if player_choice == opponent_choice
    :draw
  elsif WINNING_COMBINATIONS.include?([player_choice, opponent_choice])
    :player_win
  else
    :computer_win
  end
end

def announce(opponent, result, player_choice, opponent_choice)
  case result
  when :draw
    say "It's a draw!"
  when :player_win
    say WINNING_COMBINATIONS[[player_choice, opponent_choice]]
    say 'You win!'
  else
    say WINNING_COMBINATIONS[[opponent_choice, player_choice]]
    say "#{opponent}  wins!"
  end
end

def update_score(score, result)
  case result
  when :draw
    score[:player] += 1
    score[:computer] += 1
  when :player_win
    score[:player] += 1
  else
    score[:computer] += 1
  end
end

score = { player: 0, computer: 0 }

loop do
  opponent = OPPONENTS.sample

  opponent_says('Welcome to Rock, Scissors, Paper, Lizard, Spock!', opponent)
  opponent_says('I challenge you to a game!', opponent)

  choices = 'Rock (r), Scissors (s), Paper (p) Lizard (l) or Spock (sp)'
  opponent_says("Choose #{choices}.", opponent)
  player_choice = gets.chomp.downcase.to_sym

  until CHOICES.has_key?(player_choice)
    puts "You must choose #{choices}"
    player_choice = gets.chomp.downcase.to_sym
  end

  opponent_choice = CHOICES.keys.sample

  say '1 2 3 Go!'
  say "You throw #{CHOICES[player_choice]} #{EMOJI[player_choice]}"
  say "#{opponent}  throws #{CHOICES[opponent_choice]} #{EMOJI[opponent_choice]}"

  result = calculate_result(player_choice, opponent_choice)
  announce(opponent, result, player_choice, opponent_choice)
  update_score(score, result)

  say "Player #{score[:player]} - Challengers #{score[:computer]}"

  puts 'Try again? (y/n)'
  break if gets.chomp.downcase != 'y'
end
