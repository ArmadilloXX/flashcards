require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"

module ApiFlashcards
  RSpec.describe Api::V1::ReviewController, type: :controller do
    routes { ApiFlashcards::Engine.routes }
    it_behaves_like "http basic authentification", "get", "index"
    it_behaves_like "http basic authentification", "put", "check"

    context "with correct credentials" do
      describe "GET#index" do
        it "responds with 200 status code"
        it "responds with \'card\'' key in response"
        it "respond with only one card"
      end

      describe "PUT#check" do
        it "responds with 200 status code"
        context "when user provides correct translation" do
          it "responds with successful message"
        end
        context "when user made a typo" do
          it "responds with typo message"
        end
        context "when user provides incorrect translation" do
          it "responds with failure message"
        end
      end
    end
  end
end