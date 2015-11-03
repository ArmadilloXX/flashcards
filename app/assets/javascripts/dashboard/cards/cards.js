$(function() {
  $(".panel").hide();
  $(".loader").hide();

  $(".flickr-button").click(function() {
    $(this).hide();
    $(".panel").fadeIn();
    $("input[name=search]").focus();
  });

  $("#search-button").click(function() {
    $(".loader").show();
    $(".gallery").remove();
    var value = $("input[name=search]").val();
    $.ajax({
      url: $(this).data("url"),
      data: {
        search: value
      },
      success: function () {
        $(".loader").hide();
        $(".thumbnail").click(function() {
          $(".selected").removeClass("selected");
          $(this).addClass("selected");
          var imageUrl = $(this).find("img").attr("src");
          $("input#card_remote_image_url").val(imageUrl);
        });
      }
    });
  });
});
