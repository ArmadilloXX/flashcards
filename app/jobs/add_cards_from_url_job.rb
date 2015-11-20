require "pusher"

class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  after_perform do |job|
    sleep 5
    Pusher.trigger('bg-job-notifier',
                   'job_finished', { message: 'Your job was finished' })
  end

  def perform(*args)
    sleep 5
    Pusher.trigger('bg-job-notifier',
                   'job_started', { message: 'Your job was started' })
    CardsBatchImporter.new(args[0]).start
    user = User.find(args[0][:user]).email
    puts "#{self.class.name}: I'm performing my job for #{user} with arguments: #{args.inspect}"
  end
end
