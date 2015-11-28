require "pusher"
require "nokogiri"
require "open-uri"

class CardsBatchImporter
  attr_reader :params, :result, :originals, :translations

  def initialize(url:,
                 original_selector:,
                 translated_selector:,
                 user_id:,
                 block_id:)
    @params = {
      url: url,
      original_selector: original_selector,
      translated_selector: translated_selector,
      user_id: user_id,
      block_id: block_id
    }
    @result = {
      cards_count: 0
    }
  end

  def start
    doc = Nokogiri::HTML(open(params[:url]))
    @originals = doc.search(params[:original_selector])
    @translations = doc.search(params[:translated_selector])
    if no_cards_for_provided_selectors?
      finish("error", "No cards were found for these selectors")
    else
      create_cards
    end
  end

  def notify
    data = prepare_notification_data
    Pusher.trigger("bg-job-notifier-#{params[:user_id]}", "job_finished", data)
  end

  private

  def no_cards_for_provided_selectors?
    originals.empty? || translations.empty?
  end

  def finish(status, message)
    result[:status] = status
    result[:message] = message
  end

  def create_cards
    originals.each do |original|
      translated = translations[originals.index(original)].content.downcase
      new_card = Card.new(original_text: original.content.downcase,
                          translated_text: translated,
                          block_id: params[:block_id],
                          user_id: params[:user_id])
      if new_card.save
        result[:cards_count] += 1
      else
        finish("error", "One or more cards couldn't be saved")
        break
      end
    end
    unless result[:error]
      finish("success", "#{result[:cards_count]} cards were imported")
    end
  end

  def prepare_notification_data
    alert_type = result[:status] == "success" ? "success" : "danger"
    {
      type: alert_type,
      message: result[:message],
      url: params[:url],
      cards_count: result[:cards_count],
      block_id: params[:block_id]
    }
  end
end
