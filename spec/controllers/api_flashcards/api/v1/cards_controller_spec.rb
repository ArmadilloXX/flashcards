require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"

module ApiFlashcards
  RSpec.describe Api::V1::CardsController, type: :controller do
    it_behaves_like "http basic authentification", "get", "index"
    # routes { ApiFlashcards::Engine.routes }

    # describe "GET #index" do
    #   before { get :index }
    #   it_behaves_like "unauthorized"
    # end

    # describe "POST #create" do

    # end
  end
end