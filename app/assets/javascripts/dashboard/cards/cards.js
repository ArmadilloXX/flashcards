$(function() {
  $(".flickr_search").hide();
  $(".loader").hide();

  $('#flickr_button').click(function() {
    $(this).hide();
    $(".flickr_search").fadeIn();
  });

  $('#search_button').click(function () {
    $(".loader").show();
    $(".panel").remove();
    var value = $('input[name=search]').val();
    $.ajax({
      url: "/flickr_search/search_photos",
      data: {
        search: value
      },
      success: function () {
        $(".loader").hide();
      }
    });
  });
});
