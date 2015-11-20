
ActiveSupport::Notifications.subscribe do |name, id, payload|
  Rails.logger.debug(["Notification:", name, id, payload].join(" "))
end
# ActiveSupport::Notifications.subscribe("enqueue.active_job") do |name, id, payload|
#   Rails.logger.debug(["Notification:", name, id, payload].join(" "))
# end

# enqueue.active_job
