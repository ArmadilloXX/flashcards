$(function() {
  var pusherKey = $("#user").data("pusher-key");
  var pusher = new Pusher(pusherKey);
  var env = $("#user").data("environment");
  var userId = $("#user").data("user-id");
  var channel = pusher.subscribe("bg-job-" + env + "-notifier-" + userId);

  var notify = function(data) {
    var message = "",
        type = "";

    if (data.type == "success") {
      type = "success";
      message = data.message + " from <i>" +
                    data.url + "</i>. Check them " +
                    "<strong><a href=\"/blocks/" +
                    data.block_id + "\">here</a></strong>";
    } else{
      type = "danger";
      message = "Sorry, we got error for cards adding task: " +
                    data.message;
    }
    var html = "<div class=\"col-sm-12\"><div class=\"alert alert-dismissible" +
               " alert-" + type + "\"" + "role=\"alert\">" +
               "<button type=\"button\" class=\"close\" " +
               "data-dismiss=\"alert\" " + "aria-label=\"Close\">" +
               "<span aria-hidden=\"true\">&times;</span>" +
               "</button><p id=\"alert\">" + message + "</p></div></div>";
    var notification = $(html);
    notification.appendTo($("#notice_block")).hide();
    notification.slideDown();
  };

  channel.bind("job_finished", function(data) {
    notify(data);
  });
});