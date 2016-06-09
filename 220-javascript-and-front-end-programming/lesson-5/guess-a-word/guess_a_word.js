$(function() {
  var words = [
    "hello", "world", "banana", "orange", "panda", "computer", "ghost"
  ];
  var game  = new Game(randomWord()),
      maximum_guesses = 6,
      $word = $( "#word" ),
      $incorrect_guesses = $( "#incorrect-guesses" );

  function Game(word) {
    this.word = word;
    this.incorrect_guess_count = 0;
    this.guessed_letters = [];
    this.correct_letters = 0;
  }
  Game.prototype.number_of_guesses = 0;

  function randomWord() {
    var random_index = Math.floor(Math.random() * words.length);
    return words[random_index];
  }

  function createWordDisplay() {
    for (var i = 0; i < game.word.length; i++) {
      $word.append( "<div class='letter'></div>" );
    }
  }

  function findIndexes(letter) {
    var result = [];
    var pos = game.word.indexOf(letter);
    while (pos !== -1) {
      result.push(pos);
      pos = game.word.indexOf(letter, pos + 1);
    }
    return result;
  }

  function insertLetterAt(letter, positions) {
    for (var i = 0; i < positions.length; i++) {
      var idx = positions[i];
      $word.find( "div:eq(" + idx + ")" ).html( "<p>" + letter + "</p>" );
      game.correct_letters++;
    }
  }

  function displayIncorrectLetter(letter) {
    $incorrect_guesses.append( "<span class='guessed-letter'>"+ letter +"</span>" );
  }

  function dropApple() {
    var $apple = $( "#apple_" + game.incorrect_guess_count );
    $apple.animate({
      top: "85%"
    }, "slow", "easeOutBounce" );
  }

  function checkGameWon() {
    if (game.correct_letters === game.word.length) {
      $( "body" ).addClass( "sunny" );
      $( "nav" ).html( "<a href='index.html'>You win! Play Again</a>" );
      $(document).unbind( "keypress" );
    }
  }

  function checkGameLost() {
    if (game.incorrect_guess_count === maximum_guesses) {
      $( "body" ).addClass( "ghosty" );
      $( "nav" ).html( "<a href='index.html'>Game Over! Play Again</a>" );
      $( document ).unbind( "keypress" );
    }
  }


  $(document).on('keypress', function(e) {
    var letter_guessed = e.key;

    if (letter_guessed.match(/[a-z]/) && !game.guessed_letters.includes(letter_guessed)) {
      if (game.word.includes(letter_guessed)) {
        insertLetterAt(letter_guessed, findIndexes(letter_guessed));
      }
      else {
        displayIncorrectLetter(letter_guessed);
        game.incorrect_guess_count++;
        dropApple();
      }
      game.guessed_letters.push(letter_guessed);

      checkGameWon();
      checkGameLost();
    }
  });

  createWordDisplay();
});
