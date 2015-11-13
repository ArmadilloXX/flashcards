require "support/helpers/api_helper.rb"
include ApiHelper

module ApiFlashcards
  RSpec.shared_context "with correct credentials" do
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
    let(:endpoint) do
      {
        verb: get,
        method: "index",
      }
    end
    let(:params) { {} }

    before do
      send(endpoint[:verb],
           endpoint[:method].to_sym,
           request.headers["Authorization"] = encode("test@test.com",
                                                     "12345"),
           params
          )
    end
  end

  RSpec.shared_examples "not authorized" do
    let(:not_authorized) { { message: "Not authorized" }.to_json }

    it "returns 401 status code" do
      expect(response.status).to eq(401)
    end
    it "returns 'Not authorized' in response body" do
      expect(response.body).to eq(not_authorized)
    end
  end

  RSpec.shared_examples "unprocessable entity" do |card_params|
    let(:params) { card_params }

    describe "original_text=\'#{card_params[:card][:original_text]}\', "\
             "translated_text = \'#{card_params[:card][:translated_text]}\', "\
             "block_id = #{card_params[:card][:block_id]}" do
      it "returns 422 status code" do
        expect(response.status).to eq(422)
      end
      it "contains 'errors' key in response" do
        expect(json_response.key?("errors")).to eq(true)
      end
      it "does not create the card" do
        expect(user.cards.count).to eq(1)
      end
    end
  end
end
