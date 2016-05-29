var today = new Date();

function formattedDay(date) {
  var days_of_week = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  return days_of_week[date.getDay()];
}

function dateSuffix(numeric_date) {
  var last_digit = numeric_date % 10;

  if (last_digit === 1) { return "st"; }
  else if (last_digit === 2) { return "nd"; }
  else if (last_digit === 3) { return "rd"; }
  else { return "th"; }
}

function formattedDate(date) {
  return date.getDate() + dateSuffix(date.getDate());
}

function formattedMonth(date) {
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  return months[date.getMonth()];
}

function formattedDateText(date) {
  console.log(
    "Today's day is " + formattedDay(date) + ", " +
    formattedMonth(date) + " the " + formattedDate(date) + "."
  );
}

formattedDateText(today);

console.log(today.getFullYear());
console.log(today.getTime());

var tomorrow = new Date(today);

tomorrow.setDate(today.getDate() + 1);
formattedDate(tomorrow);

var next_week = new Date(today);
console.log(today == next_week);

console.log(today.toDateString() == next_week.toDateString());
next_week.setDate(today.getDate() + 7);
console.log(today.toDateString() == next_week.toDateString());

function formatTime(date) {
  return addZero(date.getHours()) + ":" + addZero(date.getMinutes());
}

function addZero(value) {
  return String(value).length < 2 ? "0" + value : value;
}

console.log(formatTime(today));
