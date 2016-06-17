$(function() {
  var ctx;
  var shape = "Circle";

  $( ".shape-nav" ).on( "click", function(e) {
    e.preventDefault();
    $( ".shape-nav" ).removeClass( "active" );
    $(this).addClass( "active" );
    shape = this.text;
  });

  $( "#clear" ).on( "click", function(e) {
    e.preventDefault();
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
  });

  $( "canvas" ).on( "click", function(e) {
    ctx = this.getContext("2d");
    ctx.fillStyle = "red";
    drawShape(ctx, e.offsetX, e.offsetY);
  });


  function drawShape(ctx, x, y) {
    if (shape === "Circle") {
      ctx.beginPath();
      ctx.arc(x, y, 20, 0, 2 * Math.PI);
      ctx.fill();
      ctx.closePath();
    }
    else if (shape === "Square") {
      ctx.fillRect(x - 20, y - 20, 40, 40);
    } else if (shape === "Triangle") {
      ctx.beginPath();
      ctx.moveTo(x, y - 20);
      ctx.lineTo(x + 40, y + 20);
      ctx.lineTo(x - 40, y + 20);
      ctx.lineTo(x, y - 20);
      ctx.fill();
      ctx.closePath();
    }
  }
});
