require "elasticsearch"

class Elastic
  
  def initialize
    @client ||= Elasticsearch::Client.new(
      host: '192.168.50.102:9200', # TODO Switch to env variables
      log: true
    )
  end

  def log_visit(data)
    send_to_elasticsearch("visit", data)
  end

  def log_event(data)
    send_to_elasticsearch("event", data)
  end

  def send_to_elasticsearch(type, data)
    @client.index(
      index: "new_analytics",
      type: type,
      id: data[:id],
      body: data.to_json
      )
  end
end
