require "rails_helper"

describe Dashboard::FlickrSearchController do

  context "when user provides search term" do
    it "calls the #search with search term"
  end

  context "when user does not provide search term" do

    it "calls the #getRecent" do
      get :search_photos
      # expect(Flickrie).to receive(:get_recent_photos)
    end
  end

  it "responds with js"
  it "returns an array of photos url"
  it "returns SOMETHING when no connection" #need to fix gallery template

end
