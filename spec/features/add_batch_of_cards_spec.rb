require "rails_helper"
require "support/helpers/login_helper.rb"
include LoginHelper

describe "Add batch of cards from provided url" do
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, user: user) }
  
  before(:each) do
    login_with("test@test.com", "12345", "Войти")
    visit new_batch_cards_path
  end

  describe "user enters the page" do
    it "contains url field"
    it "contains original text CSS selector field"
    it "contains translated text CSS selector field"
    it "contains block collection field"
    it "contains Start Process button"
  end

  describe "user fills the fields and start the adding process" do
    it "starts the process"
  end

  describe "process is finished" do
    it "provides the result of the process to the user"
  end
end