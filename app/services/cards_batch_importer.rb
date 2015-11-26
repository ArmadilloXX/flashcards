require "pusher"
require "nokogiri"
require "open-uri"

class CardsBatchImporter
  attr_reader :params, :cards_count, :status, :originals, :translations

  def initialize(params)
    @params = params
    @cards_count = 0
    @status = ""
  end

  def start
    doc = Nokogiri::HTML(open(params[:url]))
    @originals = doc.search("#{params[:original_selector]}")
    @translations = doc.search("#{params[:translated_selector]}")
    create_cards unless selectors_incorrect?
  end

  def notify
    data = prepare_notification_data
    Pusher.trigger("bg-job-notifier-#{params[:user_id]}", "job_finished", data)
  end

  private

  def selectors_incorrect?
    originals.empty? || translations.empty?
  end

  def create_cards
    originals.each do |original|
      translated = translations[originals.index(original)].content.downcase
      new_card = Card.new(original_text: original.content.downcase,
                          translated_text: translated,
                          block_id: params[:block_id],
                          user_id: params[:user_id])
      if new_card.save
        @cards_count += 1
      end
    end
  end

  def prepare_notification_data
    {
      type: "success",
      url: params[:url],
      cards_count: cards_count,
      block_id: params[:block_id]
    }
  end
end
