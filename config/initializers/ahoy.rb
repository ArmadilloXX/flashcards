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
    send_to_stream(visit_stream, data)
  end

  def log_event(data)
    send_to_stream(event_stream, data) 
  end

  def send_to_stream(stream_name, data)
    firehose.put_record({
      delivery_stream_name: stream_name,
      record: {
        data: data.to_json
      }
    }) 
  end

  def visit_stream
    "visits"
  end

  def event_stream
    "events"
  end
end
