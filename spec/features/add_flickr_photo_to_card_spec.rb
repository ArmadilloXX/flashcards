require "rails_helper"
require "support/helpers/login_helper.rb"
require "support/helpers/wait_for_ajax.rb"
include LoginHelper
include WaitForAjax

describe "Add Flickr photo to card" do
  let!(:user) { create(:user) }
  let!(:block) { create(:block, user: user) }
  let(:photo) { page.find("#thumbnail_0") }
  let(:start_search) do
    page.find("#flickr_button").click
    click_button "GO"
  end

  before do
    login_with("test@test.com", "12345", "Войти")
    visit new_card_path
  end

  describe "when user visits new card page", js: true do

    it "shows Search Flickr button" do
      expect(page).to have_content("Search Flickr")
    end

    it "remote_image_url textfield is hidden and blank" do
      expect(page.find(".remote_url").visible?).to eq(false)
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

    it "shows search form when user pressed button" do
      expect(page.find(".flickr_search").visible?).to eq(true)
    end
  end

  describe "when user clicks GO button for searching photos", js: true do
    before do
      start_search
    end

    it "shows loading indicator when user pressed button to search" do
      expect(page.find(".loader").visible?).to eq(true)
    end
  end

  describe "when search request is completed", js: true do
    # let!(:photos) do
    #   [
    #     "https://farm6.staticflickr.com/5742/21488769794_9fd96e7eb6_q.jpg",
    #     "https://farm1.staticflickr.com/601/21923710398_52b0732469_q.jpg",
    #     "https://farm1.staticflickr.com/705/21923710458_6fcb52ee05_q.jpg",
    #     "https://farm6.staticflickr.com/5727/22085412296_74760fb3f6_q.jpg",
    #     "https://farm1.staticflickr.com/688/22085412486_6a861b5e09_q.jpg",
    #     "https://farm1.staticflickr.com/618/22085412706_f3a85c67ef_q.jpg",
    #     "https://farm6.staticflickr.com/5724/22111607515_568962fa65_q.jpg",
    #     "https://farm1.staticflickr.com/585/22111607615_c35cff43db_q.jpg",
    #     "https://farm1.staticflickr.com/746/22111607905_cf03bc7571_q.jpg",
    #     "https://farm6.staticflickr.com/5760/22111608245_8886649659_q.jpg"
    #   ]
    # end
    before do
      # allow_any_instance_of(Dashboard::FlickrSearchController).to receive(:url_for_photos).and_return(photos)
      start_search
      wait_for_ajax
    end
    
    it "it hides loading indicator when request is finished" do
      expect(page.find(".loader").visible?).to eq(false)
    end
    it "shows results of the search" do
      expect(page).to have_selector(".gallery")
    end
  end

  describe "when user selects the photo to attach to the card", js: true do
    before do
      start_search
      wait_for_ajax
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
      wait_for_ajax
      fill_in "Оригинал", with: "Original"
      fill_in "Перевод", with: "Translation"
      select "Block 1"
      photo.click
      click_button "Сохранить"
    end

    it "saves the photo" do
      expect(user.cards.last.image?).to eq(true)
    end

    it "redirects to card index page" do
      expect(page).to have_content("Все карточки")
    end
  end
end