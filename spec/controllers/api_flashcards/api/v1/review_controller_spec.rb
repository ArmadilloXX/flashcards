require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"

module ApiFlashcards
  RSpec.describe Api::V1::ReviewController, type: :controller do
    routes { ApiFlashcards::Engine.routes }
    it_behaves_like "http basic authentification", "get", "index"
    it_behaves_like "http basic authentification", "put", "check"
  end
end