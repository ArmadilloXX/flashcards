class LogEventToFirehoseJob < ActiveJob::Base
  queue_as :firehose_logging

  def perform(*args)
    data = JSON.parse(args[0])
    fh_logger = FirehoseLogger.new
    fh_logger.log_event(data)
  end
end
