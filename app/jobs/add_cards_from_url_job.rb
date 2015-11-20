require "active_support/notifications"
class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  # after_perform do |job|
  #   ActiveSupport::Notifications.instrument("finish.active_job", job) do
  #     puts "Job finished"
  #   end
  # end

  def perform(*args)
    CardsBatchImporter.new(args[0]).start
    user = User.find(args[0][:user]).email
    puts "#{self.class.name}: I'm performing my job for #{user} with arguments: #{args.inspect}"
  end
end
