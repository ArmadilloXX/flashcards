class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  after_perform do |job|
    puts "[CALLBACK] - after_perform"
    puts job.inspect
    @importer.notify
  end

  def perform(*args)
    @importer = CardsBatchImporter.new(args[0])
    @importer.start
    # user = User.find(args[0][:user]).email
    # puts "#{self.class.name}: I'm performing my job for #{user} with arguments: #{args.inspect}"
  end
end
