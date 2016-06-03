$(function() {
  $("ul > li > a").on("click", function(e) {
    e.preventDefault();
    var $e = $(this); // pass in the dom element and return a jquery object

    $e.siblings(".modal").css({
      top: $(window).scrollTop() + 30
    });

    $e.nextAll("div").fadeIn(400);
  });

  $(".modal-layer, a.close").on("click", function(e) {
    e.preventDefault();

    $(".modal-layer, .modal").filter(":visible").fadeOut(400);
  });
});
