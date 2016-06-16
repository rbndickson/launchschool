$(function() {
  if (localStorage.getItem('activeTabIndex')) {
    setMain(localStorage.getItem('activeTabIndex'));
  }
  if (localStorage.getItem('backgroundColor')) {
    var background_color = localStorage.getItem('backgroundColor');
    $('input[value="'+ background_color + '"]').attr('checked', true);
    setBackgroundColor(background_color);
  }
  if (localStorage.getItem('savedText')) {
    setText(localStorage.getItem('savedText'));
  }

  $( "form input" ).on( "click", function(e) {
    setBackgroundColor(this.value);
    localStorage.setItem('backgroundColor', this.value);
  });

  $( "a" ).on( "click", function(e) {
    e.preventDefault();
    var index = this.id.slice(-1);
    localStorage.setItem('activeTabIndex', index);
    setMain(index);
  });

  $( window ).unload(function() {

    localStorage.setItem('savedText', $( "textarea" ).val());
  });

  function setMain(index) {
    setTab(index);
    setArticle(index);
  }

  function setTab(index) {
    $( "a" ).removeClass( "active" );
    $( "#tab_" + index ).addClass( "active" );
  }

  function setArticle(index) {
    $( "article" ).removeClass( "show-content" );
    $( "#article_" + index ).addClass( "show-content" );
  }

  function setBackgroundColor(color) {
    $( "body" ).css( "background-color", color);
  }

  function setText(text) {
    $( "textarea" ).val(text);
  }
});
