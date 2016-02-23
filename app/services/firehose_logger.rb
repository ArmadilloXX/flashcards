require "aws-sdk"

class FirehoseLogger
  attr_reader :visit_stream, :event_stream

  def initialize
    @client ||= Aws::Firehose::Client.new
    @visit_stream = ENV["FIREHOSE_VISIT_STREAM"]
    @event_stream = ENV["FIREHOSE_EVENT_STREAM"]
  end

  def log_visit(data)
    send_to_stream(visit_stream, data)
  end

  def log_event(data)
    send_to_stream(event_stream,data)
  end

  protected

  def send_to_stream(stream_name, data)
    @client.put_record({
      delivery_stream_name: stream_name,
      record: {
        data: data.to_json
      }
    })
  end
end
