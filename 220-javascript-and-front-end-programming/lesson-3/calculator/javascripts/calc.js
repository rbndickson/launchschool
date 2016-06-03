$(document).ready(function() {
  $("form").on("submit", function(e) {
    e.preventDefault();

    var first_number = +$("#first_number").val(); // + changes str to int
    var second_number = +$("#second_number").val();
    var operator = $("#operator").val();
    var message;

    if (operator === "+") {
      message = first_number + second_number;
    }
    else if (operator === "-") {
      message = first_number - second_number;
    }
    else if (operator === "*") {
      message = first_number * second_number;
    }
    else if (operator === "/") {
      message = first_number / second_number;
    }

    $("h1").text(message);
  });

  $("a").on("click", function(e) {
    e.preventDefault();
    $("h1").text(0);
  });
});
