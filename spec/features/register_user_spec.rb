require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'register_user' do
  before do
    visit root_path
  end

  context 'with correct data' do
    before(:each) do
      register('test@test.com', '12345', '12345', 'Зарегистрироваться')
    end

    it 'register successf' do
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
