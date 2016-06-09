$(function() {
  var words = [
    "hello", "world", "banana", "orange", "panda", "computer", "ghost"
  ];
  var game  = new Game(randomWord()),
      maximum_guesses = 6,
      $body = $( "body" ),
      $nav = $( "nav" ),
      $word = $( "#word" ),
      $incorrect_guesses = $( "#incorrect-guesses" );

  function Game(word) {
    this.word = word;
    this.incorrect_guess_count = 0;
    this.guessed_letters = [];
    this.correct_letters = 0;
  }

  function randomNumberBetween(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }

  function randomWord() {
    var random_index = Math.floor(Math.random() * words.length);
    return words.splice(random_index, 1)[0];
  }

  function createDisplay() {
    createWordDisplay();
    createApples();
  }

  function createWordDisplay() {
    for (var i = 0; i < game.word.length; i++) {
      $word.append( "<div class='letter'></div>" );
    }
  }

  function createApples() {
    for (var i = 0; i < maximum_guesses; i++) {
      var left = randomNumberBetween(25, 72) + "%";
      var top = randomNumberBetween(15, 65) + "%";
      var css = "style='top:" + top + "; left:" + left + "'";
      $( "#tree" ).append( "<div id='apple_" + i + "' class='apple'" + css + "></div>" );
    }
  }

  function resetDisplay() {
    $( ".letter" ).remove();
    $( ".apple" ).remove();
    $( ".guessed-letter" ).remove();
    $body.removeClass( "sunny" );
    $body.removeClass( "ghosty" );
    $nav.empty();
  }

  function findIndexes(letter) {
    var result = [];
    var position = game.word.indexOf(letter);
    while (position !== -1) {
      result.push(position);
      position = game.word.indexOf(letter, position + 1);
    }
    return result;
  }

  function insertLetterAt(letter, positions) {
    for (var i = 0; i < positions.length; i++) {
      $word.find( "div:eq(" + positions[i] + ")" ).html( "<p>" + letter + "</p>" );
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

  function checkGameOver() {
    if (game.correct_letters === game.word.length) {
      gameWon();
      gameOver();
    } else if (game.incorrect_guess_count === maximum_guesses) {
      gameLost();
      gameOver();
    }
  }

  function gameWon() {
    $body.addClass( "sunny" );
    $nav.html( "<a href='#' id='again'>You win! Play Again</a>" );
  }

  function gameLost() {
    $body.addClass( "ghosty" );
    $nav.html( "<a href='#'>Game Over! Play Again</a>" );
  }

  function gameOver() {
    $(document).off('keypress', checkGuess);

    $( "nav a" ).on( "click", function(e) {
      e.preventDefault();
      if (words.length !== 0) {
        game  = new Game(randomWord());
        resetDisplay();
        createDisplay();
        $(document).on('keypress', checkGuess);
      }
      else {
        $nav.html( "No more words left to guess!" );
      }
    });
  }

  function checkGuess(e) {
    var letter_guessed = e.key;

    if (letter_guessed.match(/[a-z]/) && !game.guessed_letters.includes(letter_guessed)) {
      if (game.word.includes(letter_guessed)) {
        insertLetterAt(letter_guessed, findIndexes(letter_guessed));
      }
      else {
        displayIncorrectLetter(letter_guessed);
        dropApple();
        game.incorrect_guess_count++;
      }
      game.guessed_letters.push(letter_guessed);

      checkGameOver();
    }
  }

  createDisplay();
  $(document).on('keypress', checkGuess);
});
