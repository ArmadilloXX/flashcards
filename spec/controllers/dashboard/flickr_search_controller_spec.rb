require "rails_helper"
require "support/helpers/flickr_helper.rb"
include FlickrHelper

describe Dashboard::FlickrSearchController do
  let(:user) { create(:user) }
  before do
    stub_flickr_requests
    @controller.send(:auto_login, user)
  end

  after do
    Rails.cache.clear
  end

  describe "#search_photos" do
    it "returns recent_photos when no search params" do
      xhr :get, :search, search: "", format: "js"
      expect(assigns(:photos)).to eq(@recent)
    end

    it "returns proper photos when user provides search params" do
      xhr :get, :search, search: "coffee", format: "js"
      expect(assigns(:photos)).to eq(@search_result)
    end
  end

  describe "provides caching for Flickr requests" do
    it "does not have a cache key before request" do
      expect(Rails.cache.exist?("flashcards_test:flickr_search_coffee")).to eq(false)
    end

    it "creates cache key for request when user provides search params" do
      xhr :get, :search, search: "coffee", format: "js"
      expect(Rails.cache.exist?("flashcards_test:flickr_search_coffee")).to eq(true)
    end

    it "uses cache for same requests after cache key was created" do
      xhr :get, :search, search: "coffee", format: "js"
      expect(Flickr.photos).not_to receive(:search).with(any_args)
      xhr :get, :search, search: "coffee", format: "js"
    end
  end
end
