$(function() {
  var photos;
  var photos_template = Handlebars.compile($( "#photos-template" ).html());
  var photo_info_template = Handlebars.compile($( "#photo-info-template" ).html());
  var comments_template = Handlebars.compile($( "#comments" ).html());
  var comment_partial = Handlebars.compile($( "#comment" ).html());
  Handlebars.registerPartial( "comment", $( "#comment" ).html());

  // initial page load
  $.ajax({
    url: "/photos"
  }).done(function(json) {
      photos = json;
      renderPhotos();
      renderPhotoInfo(1);
      getCommentsFor(photos[0].id);
    });

  // likes and faves
  $("#photo-info").on("click", ".buttons a", function(e) {
    e.preventDefault();
    var $e = $(e.target); // the a element

    $.ajax({
      url: $e.attr("href"),
      type: "post",
      data: "photo_id=" + $e.attr("data-id")
    }).done(function(json) {
      $e.text(function(i, txt) {
        return txt.replace(/\d+/, json.total);
      });
    });
  });

  $("form").on("submit", function(e) {
    e.preventDefault();
    var $f = $(this);

    $.ajax({
      url: $f.attr("action"),
      type: $f.attr("method"),
      data: $f.serialize()
    }).done(function(json) {
      $( "form input" ).val( "" );
      $( "form textarea" ).val( "" );
      $("#comments-container").append(comment_partial(json));
    });
  });

  function renderPhotos() {
    $( "#photos" ).html(photos_template({ photos: photos }));
  }

  function getCommentsFor(id) {
    $.ajax({
      url: "/comments",
      data: "photo_id=" + id
    }).done(function(comments_json) {
        renderComments(comments_json);
      });
  }

  function renderComments(comments) {
    $( "#comments-container" ).html(comments_template({ comments: comments }));
  }

  function renderPhotoInfo(id) {
    $( "#photo-info" ).html(photo_info_template(photos[id - 1]));
  }

  function renderPhotoContent(id) {
    $( "[name=photo_id]" ).val(id);
    renderPhotoInfo(id);
    getCommentsFor(id);
  }

  // slide left
  $( "#left-pager" ).on( "click", function(e) {
    e.preventDefault();
    var current_photo_id = +$( "figure:first-of-type" ).attr("data-id");
    var previous_photo_id = current_photo_id - 1;
    if (previous_photo_id < 1) { previous_photo_id = photos.length; }

    $( 'figure[data-id="'+ current_photo_id +'"]' ).prependTo( "#photos" ).hide();
    $( 'figure[data-id="'+ previous_photo_id +'"]' ).prependTo( "#photos" ).hide().fadeIn(3000);

    renderPhotoContent(previous_photo_id);
  });

  // slide right
  $( "#right-pager" ).on( "click", function(e) {
    e.preventDefault();
    var current_photo_id = +$( "figure:first-of-type" ).attr("data-id");
    var next_photo_id;
    if (current_photo_id === photos.length) {
      next_photo_id = 1;
    } else {
      next_photo_id = current_photo_id + 1;
    }
    $( 'figure[data-id="'+ current_photo_id +'"]' ).prependTo( "#photos" ).hide();
    $( 'figure[data-id="'+ next_photo_id +'"]' ).prependTo( "#photos" ).hide().fadeIn(3000);

    renderPhotoContent(next_photo_id);
  });
});
