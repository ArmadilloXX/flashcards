SwaggerEngine.configure do |config|
  config.json_files = {
    v1: "#{Rails.public_path.to_s}/api/v1/docs.json"
  }
end