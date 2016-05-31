var paragraph = "In the midway of this our mortal life, " +
"I found me in a gloomy wood, astray " +
"Gone from the path direct: and e'en to tell " +
"It were no easy task, how savage wild " +
"That forest, how robust and rough its growth, " +
"Which to remember only, my dismay " +
"Renews, in bitterness not far from death. " +
"Yet to discourse of what there good befell, " +
"All else will I relate discover'd there. " +
"How first I enter'd it I scarce can say, " +
"Such sleepy dullness in that instant weigh'd " +
"My senses down, when the true path I left, " +
"But when a mountain's foot I reach'd, where clos'd " +
"The valley, that had pierc'd my heart with dread, " +
"I look'd aloft, and saw his shoulders broad " +
"Already vested with that planet's beam, " +
"Who leads all wanderers safe through every way.";

var words;
var word_counts = {};
var most_frequent_word = '';
var highest_word_frequency = 0;

paragraph = paragraph.replace(/[,.]/g, "");
words = paragraph.split(" ");

function addWords(arr, obj) {
  for (var i = 0; i < arr.length; i++) {
    var word = arr[i];
    if (obj.hasOwnProperty(word)) {
      obj[word] += 1;
    }
    else {
      obj[word] = 1;
    }
  }
}

addWords(words, word_counts);

for (var prop in word_counts) {
  if (word_counts[prop] > highest_word_frequency) {
    most_frequent_word = prop;
    highest_word_frequency = word_counts[prop];
  }
}

console.log(word_counts);
console.log("Total words is " + words.length + ".");
console.log(
  "Most frequent word is '" + most_frequent_word + "' with " + highest_word_frequency + " occurences."
);
