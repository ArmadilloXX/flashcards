require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"

module ApiFlashcards
  RSpec.describe MainController, type: :controller do
    it_behaves_like "http basic authentification", "get", "welcome"
  end
end
