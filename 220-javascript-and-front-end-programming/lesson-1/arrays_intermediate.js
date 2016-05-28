// 1.
// Write a function that returns a new array of the elements in odd positions
// of an array parameter.

function oddElementsOf(arr) {
  var odd_elements = [];
  for (var i = 1, length = arr.length; i < length; i += 2) {
    odd_elements.push(arr[i]);
  }
  return odd_elements;
}

var digits = [4, 8, 15, 16, 23, 42];

console.log(oddElementsOf(digits)); // Returns [8, 16, 42]

// 2.
// Write a function that accepts two arrays and returns a new array whose even
// positions are from the first array and odd positions are from the second
// array. Assume both arrays are equal length.

function combinedArray(even, odd) {
  var combined_elements = [];
  for (var i = 0, length = even.length; i < length; i++) {
    combined_elements.push(even[i]);
    combined_elements.push(odd[i]);
  }
  return combined_elements;
}

var digits = [4, 8, 15, 16, 23, 42];
var letters = ['A', 'L', 'V', 'A', 'R', 'H'];

console.log(combinedArray(digits, letters));
// Returns [4, 'A', 8, 'L', 15, 'V', 16, 'A', 23, 'R', 42, 'H']

// 3.
// Write a function that returns a new array that contains a combination
// of the existing array elements as-is and the array elements in reverse order.

function reverseCombinationArray(arr) {
  var reverse_combinations = [];
  for (var i = 0, length = arr.length; i < length; i++) {
    reverse_combinations.push(arr[i]);
    reverse_combinations.push(arr[arr.length - i - 1]);
  }
  return reverse_combinations;
}

var letters = ['A', 'L', 'V', 'A', 'R', 'H'];

console.log(reverseCombinationArray(letters));
// Returns ['A', 'H', 'L', 'R', 'V', 'A', 'A', 'V', 'R', 'L', 'H', 'A']

function mirroredArray(arr) {
  return arr.concat(arr.slice().reverse());
}

var letters = ['A', 'L', 'V', 'A', 'R', 'H'];

console.log(mirroredArray(letters));
// returns [ 'A', 'L', 'V', 'A', 'R', 'H', 'H', 'R', 'A', 'V', 'L', 'A' ]

// 4.
// Write a function that accepts an array and a string. The function should
// return a string of the array elements joined together with the string used
// to join the elements together. An array ["a", "b", "c] and a string "+"
// should return "a+b+c". If no joining string is passed, use an empty string.

function joinArray(arr, joiner) {
  return arr.join([joiner]);
}

console.log(joinArray(["a", "b", "c"], "+")); // Returns "a+b+c"
console.log(joinArray([1, 4, 1, 5, 9, 2, 7])); // Returns "1415927"

// or
// function joinArray(arr, joiner) {
//   return arr.join(joiner || "");
// }

// 5.
// Using the array sort method, create a function that accepts an array of
// numbers and returns a new array of the numbers sorted in descending order.

function sortDescending(arr) {
  return arr.sort(compareNumbersDecending);
}

function compareNumbersDecending(a, b) {
  return b - a;
}

console.log(sortDescending([23, 4, 16, 42, 8, 15])); // Returns [42, 23, 16, 15, 8, 4]

// 6.
// Write a function that accepts an array of arrays and returns a new array
// containing the sums of each of the sub arrays.

function matrixSums(arr) {
  var sums = [];
  for (var i = 0, length = arr.length; i < length; i++) {
    var sum = arr[i].reduce( (prev, curr) => prev + curr );
    sums.push(sum);
  }
  return sums;
}

console.log(matrixSums([[2, 8, 5], [12, 48, 0], [12]])); // Returns [15, 60, 12]

// 7.
// Write a function that takes an array and returns a new array with duplicate
// elements removed.

function uniqueElements(arr) {
  var unique_elements = [];
  for (var i = 0, length = arr.length; i < length; i++) {
    if (unique_elements.indexOf(arr[i]) === -1) {
      unique_elements.push(arr[i])
    }
  }
  return unique_elements;
}

console.log(uniqueElements([1, 2, 4, 3, 4, 1, 5, 4])); // Returns [1, 2, 3, 4, 5]
