class CardsAdder
  @queue = :adding_cards

  def self.perform
    puts "CardsAdder starts to process"
  end
end
