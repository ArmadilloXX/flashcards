module ApiHelper
  def encode(email, password)
    ActionController::HttpAuthentication::Basic.
      encode_credentials(email, password)
  end

  def json_response
    JSON.parse(response.body)
  end
end