$(document).ready(function() {
  $("body>header").prependTo("body");
  $("main>h1").prependTo("body>header");
  $("figure:last-of-type figcaption").insertAfter("figure:first-of-type img");
  $("figure:first-of-type figcaption:last-of-type").insertAfter("figure:last-of-type img");
  $("section figure:last-of-type").insertAfter("article p");
  $("section figure").appendTo("article");
});
