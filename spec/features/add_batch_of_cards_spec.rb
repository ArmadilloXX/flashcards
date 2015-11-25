require "rails_helper"
require "support/helpers/login_helper.rb"
include LoginHelper

describe "Add batch of cards from provided url" do
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, title: "TestBlock", user: user) }
  let(:fill_and_start) do
    fill_in "URL", with: "http://www.learnathome.ru/blog/100-beautiful-words"
    fill_in "Original text CSS selector", with: "table tr td:nth-child(2) p"
    fill_in "Translated text CSS selector", with: "table tr td:first-child p"
    select "TestBlock"
    click_button "Add cards"
  end

  before(:each) do
    login_with("test@test.com", "12345", "Войти")
    visit new_batch_cards_path
  end

  describe "user enters the page" do
    it "contains url field" do
      expect(page).to have_selector("#batch_url")
    end
    it "contains original text CSS selector field" do
      expect(page).to have_selector("#batch_original_selector")
    end
    it "contains translated text CSS selector field" do
      expect(page).to have_selector("#batch_translated_selector")
    end
    it "contains block collection field" do
      expect(page).to have_selector("#batch_block_id")
    end
    it "contains Add cards button" do
      expect(page).to have_selector("#add_cards_button")
    end
  end

  describe "user fills the fields and click Add cards button" do
    before do
      fill_and_start
    end

    it "redirects to all cards page" do
      expect(page).to have_content("Все карточки")
    end

    it "shows info alert" do
      expect(page).to have_content(/was created/)
    end

    it "creates the active job" do
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 1
    end
  end

  describe "process is finished" do
    before do
      
    end

    it "shows the result message" do
      fill_and_start
      sleep 20
      expect(page).to have_content(/cards were added/)
    end
  end
end
