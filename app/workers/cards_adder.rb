class CardsAdder
  @queue = :adding_cards

  def self.perform(params)
    puts "CardsAdder starts to adding cards from '#{params["url"]}'"
    flash[:success] = "Job was finished"
  end
end
