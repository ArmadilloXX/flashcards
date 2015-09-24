require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'password authentication' do
  describe 'register' do
    before do
      visit root_path
    end

    context 'with correct data' do
      before(:each) do
        register('test@test.com', '12345', '12345', 'Зарегистрироваться')
      end

      it 'register TRUE' do
        expect(page).to have_content 'Пользователь успешно создан.'
      end

      it 'e-mail has already been taken' do
        click_link 'Выйти'
        register('test@test.com', '12345', '12345', 'Зарегистрироваться')
        expect(page).to have_content 'Не уникальное значение.'
      end
    end

    context "with incorrect data" do
      it 'password confirmation FALSE' do
        register('test@test.com', '12345', '56789', 'Зарегистрироваться')
        expect(page).to have_content "Значения не совпадают."
      end

      it 'e-mail FALSE' do
        register('test', '12345', '12345', 'Зарегистрироваться')
        expect(page).to have_content 'Не верный формат.'
      end

      it 'password is too short' do
        register('test@test.com', '1', '12345', 'Зарегистрироваться')
        expect(page).to have_content 'Короткое значение.'
      end

      it 'password_confirmation is too short' do
        register('test@test.com', '12345', '1', 'Зарегистрироваться')
        expect(page).to have_content 'Значения не совпадают.'
      end
    end
  end

  describe 'authentication' do
    before(:each) do
      create(:user)
      visit root_path
    end

    it 'require_login root' do
      expect(page).to have_content 'Добро пожаловать.'
    end

    it 'authentication TRUE' do
      login('test@test.com', '12345', 'Войти')
      expect(page).to have_content 'Вход выполнен успешно.'
    end

    context 'with incorrect data' do
      let(:error_message) { 'Вход не выполнен. Проверте вводимые E-mail и Пароль.' }

      it 'incorrect e-mail' do
        login('1@1.com', '12345', 'Войти')
        expect(page).to have_content error_message
      end

      it 'incorrect password' do
        login('test@test.com', '56789', 'Войти')
        expect(page).to have_content error_message
      end

      it 'incorrect e-mail and password' do
        login('1@1.com', '56789', 'Войти')
        expect(page).to have_content error_message
      end
    end
  end

  describe 'change language' do
    
    before(:each) do
      visit root_path
      click_link 'en'
    end

    context 'when user not logged in' do
      it 'home page' do
        expect(page).to have_content 'Welcome.'
      end
    end

    context 'when new user registering' do
      let(:register_user) { register('test@test.com', '12345', '12345', 'Sing up') }
      it 'register TRUE' do
        register_user
        expect(page).to have_content 'User created successfully.'
      end

      it 'default locale' do
        register_user
        user = User.find_by_email('test@test.com')
        expect(user.locale).to eq('en')
      end

      it 'available locale' do
        register_user
        click_link 'User profile'
        fill_in 'user[password]', with: '12345'
        fill_in 'user[password_confirmation]', with: '12345'
        click_button 'Save'
        expect(page).to have_content 'User profile updated successfully'
      end
    end

    context "when user logging in" do
      let!(:eng_user) {create(:user, locale: 'en')}
      it 'authentication TRUE' do
        login('test@test.com', '12345', 'Log in')
        expect(page).to have_content 'Login is successful.'
        ## NOTICE
        ## The line below fixes strange bug (seed 41842) when some tests in trainer_spec are failing,
        ## because this user is staying logged in
        click_link 'Log out'
      end
    end
  end
end
