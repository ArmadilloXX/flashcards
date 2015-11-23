require "pusher"
require "nokogiri"
require "open-uri"

class CardsBatchImporter
  attr_reader :url,
              :original_selector,
              :translated_selector,
              :block_id,
              :user_id,
              :cards_count

  def initialize(batch_params)
    @url = batch_params[:url]
    @original_selector = batch_params[:original_selector]
    @translated_selector = batch_params[:translated_selector]
    @block_id = batch_params[:block_id]
    @user_id = batch_params[:user_id]
    @cards_count = 0
  end

  def start
    doc = Nokogiri::HTML(open(url))
    table = doc.search('table tr')
    table.each do |row|
      original = row.css('td[2] p')[0].content.downcase
      translated = row.css('td[1] p')[0].content.downcase
      Card.create(original_text: original,
                  translated_text: translated,
                  block_id: block_id,
                  user_id: user_id)
      @cards_count += 1
    end
  end

  def notify
    puts "inside notify method"
    sleep 5
    puts "Channel: bg-job-notifier-#{user_id}"
    Pusher.trigger("bg-job-notifier-#{user_id}",
                   "job_finished", { message: "Your job was finished. #{cards_count} cards were added",
                                     type: "success" })
  end
end