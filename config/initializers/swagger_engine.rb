SwaggerEngine.configure do |config|
  config.json_files = {
    v1: "#{Rails.root}/lib/swagger/v1/docs.json"
  }
end
