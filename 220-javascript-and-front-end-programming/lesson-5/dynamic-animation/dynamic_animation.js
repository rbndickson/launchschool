$(function() {
  var shapes = [];
  var id = 0;

  $( "form" ).on( "submit", function(e) {
    e.preventDefault();
    var starting_x  = $( "#starting_x" ).val(),
        starting_y  = $( "#starting_y" ).val(),
        finishing_x = $( "#finishing_x" ).val(),
        finishing_y = $( "#finishing_y" ).val(),
        shape_class = $("#shape").val();


    $( ".container" ).append( "<div class='" + shape_class + "' id='"+ id +"'></div>" );
    var shape = $( "#" + id );

    shape.css({
      left: starting_x + "px",
      top: starting_y + "px"
    });

    shape_data = jQuery.data( shape, "position_data", {
      start_left: starting_x,
      start_top: starting_y,
      finish_left: finishing_x,
      finish_top: finishing_y
    });

    shapes.push(shape_data);

    id += 1;
    clearInputs();
  });

  $( "#start" ).click(function(e) {
    e.preventDefault();
    resetShapes();
    animateShapes();
  });

  $( "#stop" ).on( "click", function(e) {
    e.preventDefault();
    stopShapeAnimation();
  });

  $( "#controls" ).on( "click", function(e) {
    e.preventDefault();
    $( "form" ).slideToggle();
  });

  function clearInputs() {
    $( "#starting_x" ).val('');
    $( "#starting_y" ).val('');
    $( "#finishing_x" ).val('');
    $( "#finishing_y" ).val('');
  }

  function animateShapes() {
    for (var i = 0; i < shapes.length; i++) {
      $( "#" + i ).animate({
        left: shapes[i].finish_left + "px",
        top: shapes[i].finish_top + "px",
      }, { duration: 2000, queue: false });
    }
  }

  function resetShapes() {
    for (var i = 0; i < shapes.length; i++) {
      $( "#" + i ).css({
        left: shapes[i].start_left + "px",
        top: shapes[i].start_top + "px",
      });
    }
  }

  function stopShapeAnimation() {
    for (var i = 0; i < shapes.length; i++) {
      $( "#" + i ).stop();
    }
  }
});
