class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  after_perform do |job|
    puts job.inspect
    @importer.notify
  end

  def perform(*args)
    @importer = CardsBatchImporter.new(args[0])
    @importer.start
  end
end
