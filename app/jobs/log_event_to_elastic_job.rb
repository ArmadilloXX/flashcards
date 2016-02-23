class LogEventToElasticJob < ActiveJob::Base
  queue_as :elastic_logging

  after_perform do
    puts "====== LOG TO ES FINISHED ======"
  end

  def perform(*args)
    data = JSON.parse(args[0])
    es_logger = ElasticLogger.new
    es_logger.log_event(data)
  end


end
