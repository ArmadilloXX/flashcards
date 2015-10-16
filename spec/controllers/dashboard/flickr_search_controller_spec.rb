require "rails_helper"
require "support/helpers/flickr_helper.rb"
include FlickrHelper

describe Dashboard::FlickrSearchController do
  let(:user) { create(:user) }
  
  before do
    stub_flickr_requests
    @controller.send(:auto_login, user)
  end

  it "calls the #recent_photos when no search params" do
    xhr :get, :search_flickr, {search: "", format: "js"}
    expect(assigns(:photos)).to eq(@recent)
  end

  it "calls the #search_with when user provides search params" do
    xhr :get, :search_flickr, {search: "coffee", format: "js"}
    expect(assigns(:photos)).to eq(@search_result)
  end

  it "responds with js"
  

end
