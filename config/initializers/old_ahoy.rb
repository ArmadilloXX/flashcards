# require "active_support/core_ext/date_time/conversions"
# class Ahoy::Store < Ahoy::Stores::LogStore
#   attr_reader :firehose, :elastic

#   def initialize(options)
#     super
#     @firehose = FirehoseLogger.new
#     @elastic = ElasticLogger.new
#   end

#   # def visit
#   #   user_id = user.id if user
#   #   @visit ||= {
#   #     id: ahoy.visit_id,
#   #     visitor_id: ahoy.visitor_id,
#   #     user_id: user_id
#   #   }.merge(visit_properties.to_hash)
#   # end

#   protected

#   def log_visit(data)
#     # db_timestamp = convert_to_db_timestamp(data[:started_at])
#     # data[:started_at] = db_timestamp
#     # send_to_stream(visit_stream, data)
#     # elastic_client.log_visit(data)
#     LogVisitToFirehoseJob.perform_later(data)
#     LogVisitToElasticJob.perform_later(data)
#   end

#   def log_event(data)
#     # db_timestamp = convert_to_db_timestamp(data[:time])
#     # data[:time] = db_timestamp
#     # log_event_properties(data) unless data[:properties].empty?
#     # my_data = data.reject { |k| k == :properties }
#     # send_to_stream(event_stream, my_data)
#     # elastic_client.log_event(data)
#     LogEventToFirehoseJob.perform_later(data)
#     LogEventToElasticJob.perform_later(data)
#   end

#   # def log_event_properties(data)
#   #   event_properties = prepare_event_properties(data[:id], data[:properties])
#   #   event_properties.each do |property|
#   #     property[:id] = "#{data[:id]}-#{event_properties.index(property)}"
#   #     send_to_stream(event_properties_stream, property)
#   #   end
#   # end

#   # def prepare_event_properties(event_id, properties)
#   #   event_properties = []
#   #   properties.each_pair do |key, value|
#   #     event_properties << {
#   #       event_id: event_id,
#   #       property_name: key,
#   #       property_value: value
#   #     }
#   #   end
#   #   event_properties
#   # end

#   # def convert_to_db_timestamp(datetime)
#   #   datetime.utc.to_formatted_s(:db)
#   # end

#   # def event_properties_stream
#   #   "event-properties"
#   # end
# end
