function radiansToDegrees(radians) {
  return (radians * 180) / Math.PI;
}

console.log(radiansToDegrees(1));

// abs
var degrees = -180;
console.log(Math.abs(degrees));

// square root
console.log(Math.sqrt(16777216));

// 16 to the 6th power
console.log(Math.pow(16, 6));

// rounding
var a = 50.72,
    b = 49.2,
    c = 49.86;

console.log(Math.floor(a));
console.log(Math.ceil(b));
console.log(Math.round(c));

// Create a function to return a random number between a range

function randomInteger(number_1, number_2) {
  var difference,
      min,
      max;

  if (number_1 === number_2) { return number_1; }
  else {
    min = Math.min(number_1, number_2);
    max = Math.max(number_1, number_2);
  }

  difference = max - min + 1;

  return Math.floor(Math.random() * difference) + min;
}

console.log(randomInteger(1, 2));
