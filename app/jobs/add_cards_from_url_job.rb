class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  after_perform do
    @importer.notify
  end

  def perform(*args)
    batch_params = {
      url: args[0][:url],
      original_selector: args[0][:original_selector],
      translated_selector: args[0][:translated_selector],
      user_id: args[0][:user_id],
      block_id: args[0][:block_id]
    }
    @importer = CardsBatchImporter.new(batch_params)
    @importer.start
  end
end
