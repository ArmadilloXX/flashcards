require "rails_helper"
require "shared_examples/shared_examples_for_api_controllers"
require "support/helpers/api_helper.rb"
include ApiHelper

module ApiFlashcards
  RSpec.describe Api::V1::CardsController, type: :controller do
    routes { ApiFlashcards::Engine.routes }

    describe "GET#index" do
      context "without credentials" do
        before { get :index }
        it_behaves_like "not authorized"
      end

      context "with incorrect credentials" do
        before do
          get :index,
              request.headers["Authorization"] = encode("some@test.com",
                                                        "nopass")
        end
        it_behaves_like "not authorized"
      end

      context "with correct credentials" do
        include_context "with correct credentials" do
          let(:endpoint) do
            {
              verb: "get",
              method: "index"
            }
          end
        end
        it "returns 200 status code" do
          expect(response.status).to eq(200)
        end

        it "contains 'cards' key in response" do
          expect(json_response.key?("cards")).to be(true)
        end

        it "returns the array of all user\'s cards" do
          expect(json_response["cards"]).to be_kind_of Array
        end

        %w(id original_text translated_text review_date block_id).
          each do |field|
            it "contains \'#{field}\' key inside each of the card in array" do
              expect(json_response["cards"].last.key?(field)).to eq(true)
            end
          end
      end
    end

    describe "POST#create" do
      context "without credentials" do
        before { post :create }
        it_behaves_like "not authorized"
      end

      context "with incorrect credentials" do
        before do
          post :create,
               request.headers["Authorization"] = encode("some@test.com",
                                                        "nopass")
        end
        it_behaves_like "not authorized"
      end

      context "with correct credentials" do
        include_context "with correct credentials" do
          let(:endpoint) do
            {
              verb: "post",
              method: "create"
            }
          end
        end

        context "with correct card parameters" do
          let(:params) do
            { card:
              {
                original_text: "Original2",
                translated_text:"Translation2",
                block_id: block.id
              }
            }
          end

          it "returns 201 status code" do
            expect(response.status).to eq(201)
          end
          it "creates the card" do
            expect(user.cards.count).to eq(2)
          end
          it "contains 'card' key in response" do
            expect(json_response.key?("card")).to be(true)
          end

          %w(id original_text translated_text review_date block_id).
            each do |field|
              it "contains \'#{field}\' key inside of the \'card\'" do
                expect(json_response["card"].key?(field)).to eq(true)
              end
            end
        end

        context "with incorrect card parameters" do
          it_behaves_like "unprocessable entity",
                          card:
                            {
                              original_text: "Original2",
                              translated_text: "Original2",
                              block_id: 1
                            }
          it_behaves_like "unprocessable entity",
                          card:
                            {
                              original_text: "",
                              translated_text: "Original2",
                              block_id: 1
                            }
          it_behaves_like "unprocessable entity",
                          card:
                            {
                              original_text: "Original2",
                              translated_text: "",
                              block_id: 1
                            }
          it_behaves_like "unprocessable entity",
                          card:
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
