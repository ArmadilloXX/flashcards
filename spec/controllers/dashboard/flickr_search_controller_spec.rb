require "rails_helper"
require "support/helpers/flickr_helper.rb"
include FlickrHelper

describe Dashboard::FlickrSearchController do
  let(:user) { create(:user) }
  
  before do
    # stub_request(:get, "https://api.flickr.com/services/rest?api_key=b6371db92a0a0332eccddbf0897cb935&extras=media&format=json&method=flickr.photos.getRecent&nojsoncallback=1&per_page=10").
    #          to_return(:status => 200, :body => "#{recent_response}", :headers => {})
    # stub_request(:get, "https://api.flickr.com/services/rest?api_key=b6371db92a0a0332eccddbf0897cb935&extras=media&format=json&media=photos&method=flickr.photos.search&nojsoncallback=1&per_page=10&text=coffee").
    #   to_return(:status => 200, :body => "#{search_response}", :headers => {})
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

end
