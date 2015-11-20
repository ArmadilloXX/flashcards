require "pusher"
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
    puts 'inside start method'
    sleep 5
    Pusher.trigger('bg-job-notifier',
                   'job_started', { message: 'Your job was started' })
  end

  def notify
    puts 'inside notify method'
    sleep 5
    Pusher.trigger('bg-job-notifier',
                   'job_finished', { message: 'Your job was finished' })
  end
end