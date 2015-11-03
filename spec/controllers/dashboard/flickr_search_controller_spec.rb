require "rails_helper"
require "support/helpers/flickr_helper.rb"
include FlickrHelper

describe Dashboard::FlickrSearchController do
  let(:user) { create(:user) }
  before do
    stub_flickr_requests
    @controller.send(:auto_login, user)
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
end
