$(function() {
  $(".flickr_search").hide();
  $(".loader").hide();

  $('#flickr_button').click(function() {
    $(this).hide();
    $(".flickr_search").fadeIn();
    $('input[name=search]').focus();

  });

  $('#search_button').click(function() {
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
        $('a.thumbnail').click(function() {
          var image_url = $(this).find('img').attr('src');
          $('input#card_remote_image_url').val(image_url);
        });
      }
    });
  });

  

});
