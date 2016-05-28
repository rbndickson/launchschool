// 1.
// Write a function that will return the first element of an array that is
// passed to it as a parameter.

function firstElementOf(arr) {
  return arr[0];
}

console.log(firstElementOf(["U", "S", "A"])); // Returns "U"

// 2.
// Write a function that will return the last element of an array that is
// passed to it as a parameter.

function lastElementOf(arr) {
  return arr[arr.length - 1];
}

console.log(lastElementOf(["U", "S", "A"])); // Returns "A"

// 3.
// Write a function that will accept two arguments, an array and an integer
// representing the position of the element to be returned by the function.
// What happens when we pass an index greater than the length of the array?
// What about a negative number?

function nthElementOf(arr, index) {
  return arr[index];
}

var digits = [4, 8, 15, 16, 23, 42];

console.log(nthElementOf(digits, 3)); // Returns 16
console.log(nthElementOf(digits, 8)); // What would this return?
// undefined
console.log(nthElementOf(digits, -1)); // What would this return?
// undefined

// 4.
// Can we add data into an array at a negative index? If so, why is this
// possible?

// Yes because arrays are objects in JavaScript.

// 5.
// Write a function that accepts an array as the first argument and a number as
// the second. Return a new array of elements that go from the first element
// and selects elements up to that count. Passing 3, for example, would return
// the first 3 elements of an array.

function firstNOf(arr, length) {
  return arr.slice(0, length);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(firstNOf(digits, 3)); // Returns [4, 8, 15]

// 6.
// Write a function like the previous one, except return the last n elements as
// a new array.

function lastNOf(arr, length) {
  return arr.slice(arr.length - length);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(lastNOf(digits, 3)); // Returns [16, 23, 42]

// 7.
// Using the function we have supplied you in the previous solution, what
// happens if you pass a count greater than the length of the array? How can
// you fix the behavior to return a new instance of the entire array if the
// count is greater than the array length?

function lastNOf(arr, length) {
  var index = arr.length - length;

  if (index < 0) { index = 0; }
  return arr.slice(index);
}

var digits = [4, 8, 15, 16, 23, 42];
console.log(lastNOf(digits, 8)); // Returns [4, 8, 15, 16, 23, 42]

// 8.
// Write a function that accepts two arrays as arguments and returns an array
// with the first element in the first array as well as the last element in the
// second array.

function endsOf(beginning_arr, ending_arr) {
  return [beginning_arr[0], ending_arr[ending_arr.length - 1]];
}

endsOf([4, 8, 15], [16, 23, 42]); // Returns [4, 42]
