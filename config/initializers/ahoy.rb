class Ahoy::Store < Ahoy::Stores::LogStore
  attr_reader :firehose, :elastic

  # def initialize(options)
  #   super
  #   @firehose = FirehoseLogger.new
  #   @elastic = ElasticLogger.new
  # end

  protected

  def log_visit(data)
    LogVisitToFirehoseJob.perform_later(data.to_json)
    LogVisitToElasticJob.perform_later(data.to_json)
  end

  def log_event(data)
    LogEventToFirehoseJob.perform_later(data.to_json)
    LogEventToElasticJob.perform_later(data.to_json)
  end
end
