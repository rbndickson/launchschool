$(function() {
  var $blinds = $("[id^=blind]"); // create jQuery collection
  var delay = 1500;
  var speed = 250;

  function startAnimation() {
    $blinds.each(function(i) {
      var $blind = $blinds.eq(i); // get the jQuery obj at idx i
      $blind.delay(delay * i + speed).animate({
        top: "+=" + $blind.height(),
        height: 0
      }, speed);
    });
  }

  $("a").on("click", function(e) {
    e.preventDefault();
    $blinds.finish(); // finish previous animation so 2 do not run at once
    $blinds.removeAttr("style");
    startAnimation();
  });

  startAnimation();
});
