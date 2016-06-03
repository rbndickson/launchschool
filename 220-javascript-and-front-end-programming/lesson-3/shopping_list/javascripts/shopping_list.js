$(document).ready(function() {
  $( "form" ).on( "submit", function(e) {
    e.preventDefault();
    var amount = $( "#amount" ).val();
    if (amount === '') { amount = '1'; }
    var item = $( "#item" ).val();

    $( "#list" ).append( "<li>" + amount + " " + item + "</li>" );

    $( "#amount" ).val( '' );
    $( "#item" ).val( '' );
  });

  $( "a" ).on( "click", function(e) {
    e.preventDefault();
    $( "li" ).remove();
  });
});
