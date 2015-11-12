require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"
require "support/helpers/api_helper.rb"
include ApiHelper

module ApiFlashcards
  RSpec.describe Api::V1::CardsController, type: :controller do
    routes { ApiFlashcards::Engine.routes }
    it_behaves_like "http basic authentification", "get", "index"
    it_behaves_like "http basic authentification", "post", "create"

    context "with correct credentials" do
      let!(:user) do
        User.create(email: "test@test.com",
                    password: "12345",
                    password_confirmation: "12345")
      end
      let!(:block) { Block.create(title: "Test Block", user_id: user.id) }
      let!(:card) do
        Card.create(original_text: "Original",
                    translated_text: "Translation",
                    block_id: block.id,
                    user_id: user.id)
      end

      describe "GET#index" do
        before do
          get :index,
              request.headers["Authorization"] = encode("test@test.com",
                                                         "12345")
        end

        it "returns 200 status code" do
          expect(response.status).to eq(200)
        end

        it "contains 'cards' key in response" do
          expect(json_response.has_key?("cards")).to be(true)
        end

        it "returns the array of all user\'s cards" do
          expect(json_response["cards"]).to be_kind_of Array
        end
      end

      describe "POST#create" do
        context "with correct card parameters" do
          before do
            post :create,
                 request.headers["Authorization"] = encode("test@test.com",
                                                            "12345"),
                 {card: {original_text: "Original2",
                         translated_text:"Translation2",
                         block_id: block.id }}
          end
          it "returns 201 status code" do
            expect(response.status).to eq(201)
          end
          it "creates the card" do
            expect(user.cards.count).to eq(2)
          end
          it "contains 'card' key in response" do
            expect(json_response.has_key?("card")).to be(true)
          end
        end

        context "with incorrect card parameters" do
          it_behaves_like "unprocessable entity response",
                          {
                            original_text: "Original2",
                            translated_text: "Original2",
                            block_id: 1
                          }
          it_behaves_like "unprocessable entity response",
                          {
                            original_text: "",
                            translated_text: "Original2",
                            block_id: 1
                          }
          it_behaves_like "unprocessable entity response",
                          {
                            original_text: "Original2",
                            translated_text: "",
                            block_id: 1
                          }
          it_behaves_like "unprocessable entity response",
                          {
                            original_text: "Original2",
                            translated_text: "Translation2",
                            block_id: nil
                          }
        end
      end
    end
  end
end