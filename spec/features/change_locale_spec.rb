require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'change locale' do
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

    ## NOTICE
    ## The block below fixes strange bug (seed 41842) when some tests in trainer_spec are failing,
    ## because this user is staying logged in
    after(:each) do
      click_link 'Log out'
    end

    it 'shows proper confimation message' do
      register_user
      expect(page).to have_content 'User created successfully.'
    end

    it 'changes user default locale' do
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
    it 'shows proper confimation message' do
      login('test@test.com', '12345', 'Log in')
      expect(page).to have_content 'Login is successful.'
    end
  end
end
