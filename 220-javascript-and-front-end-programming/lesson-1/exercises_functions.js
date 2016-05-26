// 1.

function average(a, b, c) {
  return sum(a, b, c) / 3;
}

console.log(average(1, 4, 10));

// 2.

function sum(a, b, c) {
  return (a + b + c);
}

console.log(sum(1, 4, 10));

// 3.

function averageOfArray(array) {
  return sumOfArray(array) / array.length;
}

console.log(averageOfArray([1, 2, 3, 4, 5]));

// 4.

function sumOfArray(array) {
  var total = 0;
  for (var i = 0, len = array.length; i < len; i++) {
    total += array[i];
  }
  return total;
}

console.log(sumOfArray([1, 2, 3, 4, 5]));

// 5.

var temperatures = [24, 22, 27, 25, 27, 22];
console.log(averageOfArray(temperatures));

// 6.

function fizzBuzz() {
  for (var counter = 1; counter <= 100; counter++) {
    var output = '';
    if (counter % 3 === 0) { output += 'Fizz'; }
    if (counter % 5 === 0) { output += 'Buzz'; }
    console.log(output || counter);
  }
}

fizzBuzz();

// 7.

function random_number(max) {
  return Math.ceil(Math.random() * max);
}

console.log(random_number(50));
