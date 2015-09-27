require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper


describe 'review cards' do
  let!(:user) { create(:user) }
  let(:update_cards) { user.cards.each { |card| card.update_attribute(:review_date,
                                                     Time.now - 3.days) } }
  let(:visit_trainer) do
    login('test@test.com', '12345', 'Войти')
    visit trainer_path
  end

  shared_examples 'no cards' do
    before do
      visit_trainer
    end
    it 'shows no cards message' do
      expect(page).to have_content 'Вы пока не добавили ни одной карточки'
    end
  end

  shared_examples 'get cards from current_block' do
    before do
      user.set_current_block(block)
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
      visit_trainer
    end
    it_behaves_like 'show translation results'
  end

  shared_examples 'show translation results' do
    it 'shows card for review' do
      expect(page).to have_content 'Оригинал'
    end
    it 'shows success message when translation is correct' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end
    it 'shows failure message when translation is incorrect' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end
    it 'shows typo message when translation has a typo' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
    it 'shows failure message when Leventstein distance more than 1' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end
  end

  describe 'when user has no current_block' do
    describe 'when user has no blocks and no cards' do
      it_behaves_like 'no cards'
    end

    describe 'when user has one block' do
      let!(:block) {create(:block, user: user)}

      describe 'and no cards' do
        it_behaves_like 'no cards'
      end

      describe 'and one card' do
        let!(:card) { create(:card, user: user, block: block) }
        before do
          update_cards
          visit_trainer
        end

        it_behaves_like 'show translation results'

        it 'correct translation quality=3' do
          fill_in 'user_translation', with: 'RoR'
          click_button 'Проверить'
          fill_in 'user_translation', with: 'RoR'
          click_button 'Проверить'
          fill_in 'user_translation', with: 'House'
          click_button 'Проверить'
          expect(page).to have_content 'Текущая карточка'
        end

        it 'correct translation quality=4' do
          fill_in 'user_translation', with: 'RoR'
          click_button 'Проверить'
          fill_in 'user_translation', with: 'RoR'
          click_button 'Проверить'
          fill_in 'user_translation', with: 'House'
          click_button 'Проверить'
          fill_in 'user_translation', with: 'House'
          click_button 'Проверить'
          expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
        end
      end

      describe 'and two cards' do
        let!(:card) { create(:card, user: user, block: block) }
        let!(:card2) { create(:card, user: user, block: block) }

        before do
          update_cards
          visit_trainer
        end

        it_behaves_like 'show translation results'
      end
    end

    describe 'when user has two blocks' do
      let!(:block) {create(:block, user: user)}
      let!(:block2) {create(:block, user: user)}

      describe 'and no cards' do
        it_behaves_like 'no cards'
      end

      describe 'and one card for each block' do
        let!(:card) { create(:card, user: user, block: block) }
        let!(:card2) { create(:card, user: user, block: block2) }

        before do
          update_cards
          visit_trainer
        end

        it_behaves_like 'show translation results'
      end

      describe 'and one card' do
        let!(:card) { create(:card, user: user, block: block) }

        before do
          update_cards
          visit_trainer
        end

        it_behaves_like 'show translation results'
      end
    end
  end

  describe 'when user has current_block' do
    let!(:block) { create(:block, user: user) }

    describe 'and no cards' do
      before do
        user.set_current_block(block)
        visit_trainer
      end
      it_behaves_like 'no cards'
    end

    describe 'and two cards in each block' do
      let!(:block2) { create(:block, user: user)}
      let!(:card) { create(:card, user: user, block: block)}
      let!(:card2) { create(:card, user: user, block: block)}
      let!(:card3) { create(:card, user: user, block: block2)}
      let!(:card4) { create(:card, user: user, block: block2)}

      it_behaves_like 'get cards from current_block'
    end

    describe 'and two cards in each block' do
      let!(:block2) { create(:block, user: user)}
      let!(:card) { create(:card, user: user, block: block)}
      let!(:card2) { create(:card, user: user, block: block2)}

      it_behaves_like 'get cards from current_block'
    end
  end
end
  