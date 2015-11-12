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
      end
      tag do
        key :name, 'Review'
      end
      key :host, 'localhost:3000'
      key :basePath, '/api/v1'
      key :produces, ['application/json']
    end

    SWAGGERED_CLASSES = [
      Api::V1::CardsController,
      Api::V1::ReviewController,
      Card,
      ErrorModel,
      self,
    ].freeze
end