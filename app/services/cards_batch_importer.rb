require "active_support/notifications"
class CardsBatchImporter
  attr_reader :url,
                :original_selector,
                :translated_selector,
                :block_id,
                :user_id

  def initialize(batch_params)
    @url = batch_params[:url]
    @original_selector = batch_params[:original_selector]
    @translated_selector = batch_params[:translated_selector]
    @block_id = batch_params[:block_id]
    @user_id = batch_params[:user_id]
  end

  def start
    # Rails.logger.debug "[IMPORT] Process started"
    puts "[IMPORT] Process started"
  end

  # def finish
  #   ActiveSupport::Notifications.instrument("finish.active_job") do
  #     puts "[IMPORT] Process finished"
  #   end
  # end
end