require "rails_helper"
require "support/helpers/login_helper.rb"
require "support/helpers/wait_for_ajax.rb"
require "support/helpers/flickr_helper.rb"
include FlickrHelper
include LoginHelper
include WaitForAjax

describe "Add Flickr photo to card" do
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, user: user) }
  let(:photo) { page.find("#thumbnail_0") }

  let(:start_search) do
    page.find("#flickr_button").click
    click_button "GO"
  end

  before(:each) do
    login_with("test@test.com", "12345", "Войти")
    stub_flickr_requests
    visit new_card_path
  end

  describe "when user visits new card page", js: true do
    it "shows Try Flickr button" do
      expect(page).to have_content("Search Flickr")
    end

    it "remote_image_url textfield is hidden" do
      expect(page.find(".remote_url").visible?).to eq(false)
    end

    it "remote_image_url textfield is blank" do
      expect(page.find(".remote_url")["value"]).to be_blank
    end

    it "loading indicator is hidden" do
      expect(page.find(".loader").visible?).to eq(false)
    end

    it "search form is hidden" do
      expect(page.find(".flickr_search").visible?).to eq(false)
    end
  end

  describe "when user clicks Try Flickr button", js: true do
    before do
      page.find("#flickr_button").click
    end

    it "shows search form" do
      expect(page.find(".flickr_search").visible?).to eq(true)
    end
  end

  describe "user clicks GO button", js: true do
    before do
      start_search
      # wait_for_ajax
    end

    context "when search is finished" do
      it "it hides loading indicator when request is finished" do
        expect(page.find(".loader").visible?).to eq(false)
      end
      it "shows results of the search" do
        expect(page).to have_selector(".gallery")
      end
    end
  end

  describe "when user selects the photo to attach to the card", js: true do
    before do
      start_search
      # wait_for_ajax
      photo.click
    end

    it "highlights the selected photo" do
      expect(photo[:class].include?("selected")).to eq(true)
    end

    it "fill the hidden remote_image_url field with proper url" do
      img_url = page.find("#photo_0")["src"]
      remote_url = page.find("#card_remote_image_url").value
      expect(remote_url).to eq(img_url)
    end
  end

  describe "when user clicks button for saving new card with photo", js: true do
    before do
      start_search
      # wait_for_ajax
      fill_in "Оригинал", with: "Original"
      fill_in "Перевод", with: "Translation"
      select "Block 1"
      photo.click
    end

    it "saves the photo" do
      WebMock.allow_net_connect!
      click_button "Сохранить"
      expect(user.cards.last.image?).to eq(true)
    end

    it "redirects to card index page" do
      WebMock.allow_net_connect!
      click_button "Сохранить"
      expect(page).to have_content("Все карточки")
    end
  end
end
