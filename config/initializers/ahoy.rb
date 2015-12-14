class Ahoy::Store < Ahoy::Stores::LogStore
  def visit
    user_id = user.id if user
    @visit ||= {
      id: ahoy.visit_id,
      visitor_id: ahoy.visitor_id,
      user_id: user_id
    }.merge(visit_properties.to_hash)
  end

  protected

  # def log_visit(data)
  #   visit_logger.info data.to_json
  # end

  # def log_event(data)
  #   event_logger.info data.to_json
  # end

  def visit_stream

  end

  def event_stream

  end
end
