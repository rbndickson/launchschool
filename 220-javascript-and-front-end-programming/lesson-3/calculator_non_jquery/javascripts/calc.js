function $(id_selector) {
  return document.getElementById(id_selector);
}

window.onload = function() {
  $("calculator").onsubmit = function(e) {
    e.preventDefault();

    var first_number = +$("first_number").value;
    var second_number = +$("second_number").value;
    var operator = $("operator").value;
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

    $("result").innerHTML = message;
  };

  $("clear").onclick = function(e) {
    e.preventDefault();
    
    $("result").innerHTML = 0;
    $("first_number").value = '';
    $("second_number").value = '';
  };
};
