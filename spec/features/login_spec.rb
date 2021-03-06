require "rails_helper"
require "support/helpers/login_helper.rb"
include LoginHelper

describe "user login" do
  before(:each) do
    create(:user)
    visit root_path
  end

  it "require_login root" do
    expect(page).to have_content "Добро пожаловать."
  end

  it "authentication TRUE" do
    login_with("test@test.com", "12345", "Войти")
    expect(page).to have_content "Вход выполнен успешно."
  end

  context "with incorrect data" do
    let(:error_message) do
      "Вход не выполнен. Проверте вводимые E-mail и Пароль."
    end

    it "incorrect e-mail" do
      login_with("1@1.com", "12345", "Войти")
      expect(page).to have_content error_message
    end

    it "incorrect password" do
      login_with("test@test.com", "56789", "Войти")
      expect(page).to have_content error_message
    end

    it "incorrect e-mail and password" do
      login_with("1@1.com", "56789", "Войти")
      expect(page).to have_content error_message
    end
  end
end
