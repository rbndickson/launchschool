// 1.

function firstElementOf(arr) {
  return arr[0];
}

console.log(firstElementOf(["U", "S", "A"])); // Returns "U"

// 2.

function lastElementOf(arr) {
  return arr[arr.length - 1];
}

console.log(lastElementOf(["U", "S", "A"])); // Returns "A"

// 3.

function nthElementOf(arr, index) {
  return arr[index];
}

var digits = [4, 8, 15, 16, 23, 42];

console.log(nthElementOf(digits, 3)); // Returns 16
console.log(nthElementOf(digits, 8)); // What would this return?
console.log(nthElementOf(digits, -1)); // What would this return?

// 5.

function firstNOf(arr, length) {
  return arr.slice(0, length);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(firstNOf(digits, 3)); // Returns [4, 8, 15]

// 6.

function lastNOf(arr, length) {
  return arr.slice(arr.length - length);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(lastNOf(digits, 3)); // Returns [16, 23, 42]

// 7.

function lastNOf(arr, length) {
  var index = arr.length - length;

  if (index < 0) { index = 0; }
  return arr.slice(index);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(lastNOf(digits, 8)); // Returns [4, 8, 15, 16, 23, 42]

// 8.

function endsOf(beginning_arr, ending_arr) {
  return [beginning_arr[0], ending_arr[ending_arr.length - 1]];
}

endsOf([4, 8, 15], [16, 23, 42]); // Returns [4, 42]
