class CardModel < ActiveRecord::Base
  include Swagger::Blocks
  swagger_schema :Card do
    key :id, :Card
    key :required, [
      :id,
      :original_text,
      :translated_text,
      :review_date,
      :block_id
    ]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :original_text do
      key :type, :string
    end
    property :translated_text do
      key :type, :string
    end
    property :block_id do
      key :type, :integer
    end
    property :review_date do
      key :type, :string
      key :format, "date-time"
    end
  end

  swagger_schema :CardResponse do
    key :id, :Card
    property :card do
      key :'$ref', :Card
    end
  end

  swagger_schema :CardsResponse do
    key :id, :Card
    property :cards do
      key :type, :array
      items do
        key :'$ref', :Card
      end
    end
  end

  swagger_schema :CardReviewResult do
    property :result do
      key :type, :string
    end
  end

  swagger_schema :CardReview do
    key :id, :Card
    key :required, [:id, :original_text]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :original_text do
      key :type, :string
    end
  end

  swagger_schema :CardReviewResponse do
    key :id, :Card
    property :card do
      key :'$ref', :CardReview
    end
  end
end