require "swagger/blocks"
module ApiFlashcards
  include Swagger::Blocks
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Flashcards API'
        key :description, 'A sample API for Flashcards App'
      end
      tag do
        key :name, 'Cards'
        key :description, 'Cards operations'
      end
      tag do
        key :name, 'Trainer'
        key :description, 'Training operations'
      end
      key :host, 'localhost:3000'
      key :basePath, '/api/v1'
      key :produces, ['application/json']
    end

    SWAGGERED_CLASSES = [
      Api::V1::CardsController,
      Card,
      ErrorModel,
      self,
    ].freeze
end