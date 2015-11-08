require "support/helpers/api_helper.rb"
include ApiHelper

module ApiFlashcards
  RSpec.shared_examples "http basic authentification" do |verb, method|
    routes { ApiFlashcards::Engine.routes }
    let!(:user) do
      User.create(email: "test@test.com",
                  password: "123456",
                  password_confirmation: "123456")
    end
    let(:not_authorized) { {message: "Not authorized"}.to_json }

    describe "#{verb.upcase}##{method}" do
      shared_examples "not authorized" do
        it "returns 401 status code" do
          expect(response.status).to eq(401)
        end
        it "returns 'Not authorized' in response body" do
          expect(response.body).to eq(not_authorized)
        end
      end

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

      context "with correct credentials" do
        before do
          send(verb,
               method.to_sym,
               request.headers["Authorization"] = encode("test@test.com",
                                                         "123456"))
        end
        it "returns 200 status code" do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
