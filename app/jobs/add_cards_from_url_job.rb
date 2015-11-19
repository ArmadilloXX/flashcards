class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  def perform(*args)
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
    ActiveSupport::Notifications.instrument("perform.active_job", args)
  end
end
