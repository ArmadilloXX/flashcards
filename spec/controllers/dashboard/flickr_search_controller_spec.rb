require "rails_helper"
require "flickraw"

describe Dashboard::FlickrSearchController do

  context "when user provides search term" do
    it "calls the #search with search term"
  end

  context "when user does not provide search term" do
    it "calls the #getRecent"
  end

  it "responds with js"
  it "returns an array of photos url"
  it "returns SOMETHING when no connection" #fix gallery template

end
