require 'rails_helper'
require 'support/helpers/login_helper.rb'
require 'support/helpers/trainer_helper.rb'
include LoginHelper
include TrainerHelper

describe "review cards" do
  let!(:user)  { create(:user) }
  let(:revision_message) { 'Ожидайте наступления даты пересмотра.' }
  let(:success_message)  { 'Вы ввели верный перевод. Продолжайте.' }
  let(:typo_message)     { 'Вы ввели перевод c опечаткой.' }
  let(:failure_message)  { 'Вы ввели не верный перевод. Повторите попытку.' }

  describe "when user has no cards" do
    before do
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it 'show the no cards message' do
      expect(page).to have_content "Вы пока не добавили ни одной карточки"
    end
  end

  describe "when user has no pending or repeating cards" do
    let!(:block) { create(:block, user: user) }
    let!(:card)  { create(:card, user: user, block: block) }

    before do
      card.update_attribute(:review_date, Time.now + 3.days)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it 'shows revision_message when has no cards for review' do
      expect(page).to have_content revision_message
    end
  end

  describe "when user has card for review" do
    let!(:block) { create(:block, user: user) }
    let!(:first_card)  { create(:card, user: user, block: block) }

    before do
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it 'shows card for review' do
      expect(page).to have_content 'Оригинал'
    end

    context 'with correct translation' do
      it 'shows success_message' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content success_message
      end
    end

    context 'with incorrect translation' do
      it 'shows failure message' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page).to have_content failure_message
      end
    end

    context 'with translation with typo' do
      it 'shows typo message' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content typo_message
      end
    end
  end
end