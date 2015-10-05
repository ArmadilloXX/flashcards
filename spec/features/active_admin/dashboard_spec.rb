require "rails_helper"
require "support/helpers/login_helper.rb"
include LoginHelper

describe "User enters admin area" do
  let(:login_and_enter) do
    login_with("test@test.com", "12345", "Войти")
    visit admin_root_path
  end

  context "when not authenticated" do
    before do
      visit admin_root_path
    end

    it "redirects to login" do
      expect(page).to have_content("Войти")
    end
  end

  context "when authenticated but not as admin" do
    let!(:user) { create(:user) }

    before do
      login_and_enter
    end

    it "shows proper alert message" do
      expect(page).to have_content(
        "Вы не авторизованы для выполнения данного действия.")
    end
    it "redirect to root path" do
      expect(page).to have_content("Добро пожаловать.")
    end
  end

  context "when authenticated as admin" do
    let!(:admin) { create(:user, :admin) }

    it "allows to enter" do
      login_and_enter
      expect(page).to have_content("Панель управления")
    end
  end
end
