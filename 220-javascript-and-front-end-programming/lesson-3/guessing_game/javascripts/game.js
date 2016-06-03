$(document).ready(function() {
  var answer = Math.floor(Math.random() * 100) + 1;
  var guesses = 0;

  $("form").on("submit", function(e) {
    e.preventDefault();

    var guess = +$("#guess").val();

    if (guess > answer) {
      message = "My number is lower than " + guess;
    }
    else if (guess < answer) {
      message = "My number is higher than " + guess;
    }
    else if (guess === answer) {
      message = "You win! The number was " + answer + "! " +
                "You took " + guesses + " guesses.";
    }
    else {
      message = "That is not a valid number!";
    }
    $("p").text(message);
    guesses++;
  });

  $("a").on("click", function(e) {
    e.preventDefault();

    answer = Math.floor(Math.random() * 100) + 1;
    guesses = 0;
    $("p").text("Guess a number from 1 to 100");
  });
});
