class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :adding_cards

  def perform(params)
    puts "CardsAdder starts to adding cards from '#{params["url"]}'"
  end
end
