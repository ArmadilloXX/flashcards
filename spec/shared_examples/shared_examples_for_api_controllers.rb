require "support/helpers/api_helper.rb"
include ApiHelper

module ApiFlashcards
  RSpec.shared_examples "http basic authentification" do |verb, method|
    let(:not_authorized) { {message: "Not authorized"}.to_json }

    shared_examples "not authorized" do
      it "returns 401 status code" do
        expect(response.status).to eq(401)
      end
      it "returns 'Not authorized' in response body" do
        expect(response.body).to eq(not_authorized)
      end
    end

    describe "#{verb.upcase}##{method}" do
      context "without credentials" do
        before do
          send(verb, method.to_sym)
        end
        it_behaves_like "not authorized"
      end

      context "with incorrect credentials" do
        before do
          send(verb,
               method.to_sym,
               request.headers["Authorization"] = encode("some@test.com",
                                                         "nopass"))
        end
        it_behaves_like "not authorized"
      end
    end
  end

  RSpec.shared_examples "unprocessable entity response" do |card_params|
    let!(:original_text) { card_params.fetch(:original_text, nil) }
    let!(:translated_text) { card_params.fetch(:translated_text, nil) }
    let!(:block_id) { card_params.fetch(:block_id, nil ) }

    describe "original_text=\'#{card_params.fetch(:original_text, nil) }\', "\
    "translated_text = \'#{card_params.fetch(:translated_text, nil)}\', "\
    "block_id = #{card_params.fetch(:block_id, nil)}" do
      before do
        post :create,
             request.headers["Authorization"] = encode("test@test.com",
                                                        "12345"),
             {card: {original_text: original_text,
                     translated_text: translated_text,
                     block_id: block_id }}
      end

      it "returns 422 status code" do
        expect(response.status).to eq(422)
      end
      it "contains 'errors' key in response" do
        expect(json_response.has_key?("errors")).to eq(true)
      end
      it "does not create the card" do
        expect(user.cards.count).to eq(1)
      end
    end
  end
end
