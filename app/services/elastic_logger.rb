require "elasticsearch"

class ElasticLogger
  attr_reader :es_index, :es_visit_type, :es_event_type

  def initialize
    @client ||= Elasticsearch::Client.new(
      host: "#{ENV['ES_HOST']}:#{ENV['ES_PORT']}",
      log: true
    )
    @es_index = ENV["ES_INDEX_NAME"]
    @es_visit_type = ENV["ES_VISIT_TYPE"]
    @es_event_type = ENV["ES_EVENT_TYPE"]
  end

  def log_visit(data)
    send_to_elasticsearch(es_visit_type, data)
  end

  def log_event(data)
    send_to_elasticsearch(es_event_type, data)
  end

  protected

  def send_to_elasticsearch(type, data)
    @client.index(
      index: es_index,
      type: type,
      id: data[:id],
      body: data.to_json
      )
  end
end
