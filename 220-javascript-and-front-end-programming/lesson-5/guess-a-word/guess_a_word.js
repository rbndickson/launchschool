var words = [
  "hello", "world", "banana", "orange", "panda", "computer", "ghost"
];

var maximum_guesses = 6,
    $body = $( "body" ),
    $nav = $( "nav" ),
    $word = $( "#word" ),
    $incorrect_guesses = $( "#incorrect-guesses" );

function randomWord() {
  var random_index = Math.floor(Math.random() * words.length);
  return words.splice(random_index, 1)[0];
}

function findIndexes(str, char) {
  var result = [];
  var idx = str.indexOf(char);
  while (idx !== -1) {
    result.push(idx);
    idx = str.indexOf(char, idx + 1);
  }
  return result;
}

function randomNumberBetween(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

function Game() {
  this.word = randomWord();
  this.incorrect_guess_count = 0;
  this.guessed_letters = [];
  this.correct_letters = 0;
  this.init();
}

Game.prototype = {
  init: function() {
    this.resetDisplay();
    this.createWordDisplay();
    this.createApples();
  },

  createWordDisplay: function() {
    for (var i = 0; i < this.word.length; i++) {
      $word.append( "<div class='letter'></div>" );
    }
  },

  createApples: function() {
    for (var i = 0; i < maximum_guesses; i++) {
      $("#tree").append($('<div></div>', {
        id: 'apple_' + i,
        class: 'apple',
        css: {
          'left': randomNumberBetween(25, 72) + "%",
          'top':  randomNumberBetween(15, 65) + "%"
        }
      }));
    }
  },

  dropApple: function() {
    var $apple = $( "#apple_" + this.incorrect_guess_count );
    $apple.animate({
      top: "85%"
    }, "slow", "easeOutBounce" );
  },

  processGuess: function(e) {
    var letter_guessed = String.fromCharCode(e.which);

    if (letter_guessed.match(/[a-z]/) && !this.guessed_letters.includes(letter_guessed)) {
      if (this.word.includes(letter_guessed)) {
        this.insertLetterAt(letter_guessed, findIndexes(this.word, letter_guessed));
      }
      else {
        this.displayIncorrectLetter(letter_guessed);
        this.dropApple();
        this.incorrect_guess_count++;
      }
      this.guessed_letters.push(letter_guessed);

      this.checkGameOver();
    }
  },

  insertLetterAt: function(letter, positions) {
    for (var i = 0; i < positions.length; i++) {
      $word.find( "div:eq(" + positions[i] + ")" ).html( "<p>" + letter + "</p>" );
      this.correct_letters++;
    }
  },

  displayIncorrectLetter: function(letter) {
    $incorrect_guesses.append( "<span class='guessed-letter'>" + letter + "</span>" );
  },

  checkGameOver: function() {
    if (this.correct_letters === this.word.length) {
      this.gameWon();
      this.gameOver();
    } else if (this.incorrect_guess_count === maximum_guesses) {
      this.gameLost();
      this.gameOver();
    }
  },

  gameWon: function() {
    $body.addClass( "sunny" );
    $nav.html( "<a href='#' id='again'>You win! Play Again</a>" );
  },

  gameLost: function() {
    $body.addClass( "ghosty" );
    $nav.html( "<a href='#'>Game Over! Play Again</a>" );
  },

  gameOver: function() {
    $(document).off('keypress', this.processGuess);

    $( "nav a" ).on( "click", function(e) {
      e.preventDefault();
      if (words.length !== 0) {
        game = new Game();
        $(document).on('keypress', $.proxy(game.processGuess, game));
      }
      else {
        $nav.html( "No more words left to guess!" );
      }
    });
  },

  resetDisplay: function() {
    $( ".letter" ).remove();
    $( ".apple" ).remove();
    $( ".guessed-letter" ).remove();
    $body.removeClass( "sunny" );
    $body.removeClass( "ghosty" );
    $nav.empty();
  },
};

var game = new Game();
$(document).on('keypress', $.proxy(game.processGuess, game));
