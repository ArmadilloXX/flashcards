class ErrorModel
  include Swagger::Blocks

  swagger_schema :Unprocessable do
    key :required, [:message, :errors]
    property :message do
      key :type, :string
    end
    property :errors do
      key :type, :string
    end
  end

  swagger_schema :NotAuthorized do
    key :required, [:message]
    property :message do
      key :type, :string
    end
  end
end