require "rails_helper"
require "support/helpers/login_helper.rb"
include LoginHelper

describe "change locale" do
  before(:each) do
    visit root_path
    click_link "en"
  end

  context "when user not logged in" do
    it "home page" do
      expect(page).to have_content "Welcome."
    end
  end

  context "when new user registering" do
    let!(:register_user) do
      register("eng_user@test.com", "123456", "123456", "Sing up")
    end

    after(:each) do
      click_link "Log out"
    end

    it "shows proper confimation message" do
      expect(page).to have_content "User created successfully."
    end

    it "changes user default locale" do
      user = User.find_by_email("eng_user@test.com")
      expect(user.locale).to eq("en")
    end

    it "available locale" do
      click_link "User profile"
      fill_in "user[password]", with: "123456"
      fill_in "user[password_confirmation]", with: "123456"
      click_button "Save"
      expect(page).to have_content "User profile updated successfully"
    end
  end

  context "when user logging in" do
    let!(:eng_user) do
      create(
        :user,
        email: "eng_user@test.com",
        password: "123456",
        password_confirmation: "123456",
        locale: "en")
    end
    it "shows proper confimation message" do
      login("eng_user@test.com", "123456", "Log in")
      expect(page).to have_content "Login is successful."
      click_link "Log out"
    end
  end
end
