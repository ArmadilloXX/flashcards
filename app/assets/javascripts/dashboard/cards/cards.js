$(function() {
  $(".flickr_search").hide();
  $('#flickr_button').click(function() {
    $(this).hide();
    $(".flickr_search").fadeIn();
  });
});
