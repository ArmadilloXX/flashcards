require "aws-sdk"
class Ahoy::Store < Ahoy::Stores::LogStore
  attr_reader :firehose

  def initialize(options)
    super
    #TODO Switch to env variables
    @firehose ||= Aws::Firehose::Client.new(region: 'us-west-2')
  end

  def visit
    user_id = user.id if user
    @visit ||= {
      id: ahoy.visit_id,
      visitor_id: ahoy.visitor_id,
      user_id: user_id
    }.merge(visit_properties.to_hash)
  end

  protected

  def log_visit(data)
    firehose.put_record({
      delivery_stream_name: visit_stream,
      record: {
        data: data.to_json
      }
    }) 
  end

  # def log_event(data)
  #   event_logger.info data.to_json
  # end

  def visit_stream
    'test-stream'
  end

  def event_stream

  end
end
