require 'rails_helper'

describe Card do
  let(:card) { Card.new(original_text: 'дом',
                        translated_text: 'house',
                        user_id: 1,
                        block_id: 1) }

  describe "create card" do
    context "has validation errors" do
      let(:diff_message) { 'Вводимые значения должны отличаться.' }

      it 'with empty original text' do
        card.update(original_text: '')
        expect(card.errors[:original_text]).
            to include('Необходимо заполнить поле.')
      end

      it 'with empty translated text' do
        card.update(translated_text: '')
        expect(card.errors[:translated_text]).
            to include('Необходимо заполнить поле.')
      end

      it 'with both empty texts' do
        card.update(original_text: '', translated_text: '')
        expect(card.errors[:original_text]).
            to include diff_message
      end

      it 'with equal_texts Eng' do
        card.update(original_text: 'house')
        expect(card.errors[:original_text]).
            to include diff_message
      end

      it 'with equal_texts Rus' do
        card.update(original_text: 'дом', translated_text: 'дом')
        expect(card.errors[:original_text]).
            to include diff_message
      end

      it 'provides full_downcase Eng' do
        card.update(original_text: 'hOuse', translated_text: 'houSe')
        expect(card.errors[:original_text]).
            to include diff_message
      end

      it 'provides full_downcase Rus' do
        card.update(original_text: 'Дом', translated_text: 'доМ')
        expect(card.errors[:original_text]).
            to include diff_message
      end

      it 'without user_id' do
        card.update(user_id: nil)
        expect(card.errors[:user_id]).
            to include('Ошибка ассоциации.')
      end

      it 'without block_id' do
        card.update(block_id: nil)
        expect(card.errors[:block_id]).
            to include('Выберите колоду из выпадающего списка.')
      end
    end

    context 'with correct data' do
      before do
        card.save
      end

      it 'has original_text OK' do
        expect(card.original_text).to eq('дом')
      end

      it 'has translated_text OK' do
        expect(card.translated_text).to eq('house')
      end

      it 'has no card errors OK' do
        expect(card.errors.any?).to be false
      end

      it 'set_review_date OK' do
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
      end
    end
  end

  describe '#check_translation returns correct data' do
    before do
      card.save
      check_result
    end

    context 'when translation is correct' do
      let(:check_result) { card.check_translation('house') }

      it 'returns state attribute equal to true' do
        expect(check_result[:state]).to be true
      end
      it 'returns distance attribute equal to 0' do
        expect(check_result[:distance]).to eq(0)
      end

      # it 'check_translation Eng OK' do
      #   card = Card.create(original_text: 'дом', translated_text: 'house',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('house')
      #   expect(check_result[:state]).to be true
      # end

      # it 'check_translation Rus OK' do
      #   card = Card.create(original_text: 'house', translated_text: 'дом',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('дом')
      #   expect(check_result[:state]).to be true
      # end

      # it 'check_translation full_downcase Eng OK' do
      #   card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
      #                      user_id: 1, block_id: 1)

      #   check_result = card.check_translation('HousE')
      #   expect(check_result[:state]).to be true
      # end

      # it 'check_translation full_downcase Rus OK' do
      #   card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('дОм')
      #   expect(check_result[:state]).to be true
      # end
    end

    context 'when translation has a typo' do
      let(:check_result) { card.check_translation('hous') }

      it 'returns attribute equal to true' do
        expect(check_result[:state]).to be true
      end

      it 'returns attribute equal to 1' do
        expect(check_result[:distance]).to eq(1)
      end

      # it 'check_translation Eng OK levenshtein_distance' do
      #   card = Card.create(original_text: 'дом', translated_text: 'hous',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('house')
      #   expect(check_result[:state]).to be true
      # end

      # it 'check_translation Eng OK levenshtein_distance=1' do
      #   card = Card.create(original_text: 'дом', translated_text: 'hous',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('house')
      #   expect(check_result[:distance]).to be 1
      # end

      # it 'check_translation Rus OK levenshtein_distance' do
      #   card = Card.create(original_text: 'house', translated_text: 'до',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('дом')
      #   expect(check_result[:state]).to be true
      # end

      # it 'check_translation Rus OK levenshtein_distance=1' do
      #   card = Card.create(original_text: 'house', translated_text: 'до',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('дом')
      #   expect(check_result[:distance]).to be 1
      # end
    end

    context 'when translation is incorrect' do
      let(:check_result) { card.check_translation('RoR') }

      it 'returns state attribute equal to false' do
        check_result = card.check_translation('RoR')
        expect(check_result[:state]).to be false
      end

      it 'returns distance attribute > 1' do
        check_result = card.check_translation('RoR')
        expect(check_result[:distance]).to be > 1
      end
    end

      # it 'check_translation Eng NOT' do
      #   card = Card.create(original_text: 'дом', translated_text: 'house',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end

      # it 'check_translation Rus NOT' do
      #   card = Card.create(original_text: 'house', translated_text: 'дом',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end

      # it 'check_translation full_downcase Eng NOT' do
      #   card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end

      # it 'check_translation full_downcase Rus NOT' do
      #   card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end

      # it 'check_translation Eng NOT levenshtein_distance=2' do
      #   card = Card.create(original_text: 'дом', translated_text: 'hou',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end

      # it 'check_translation Rus NOT levenshtein_distance=2' do
      #   card = Card.create(original_text: 'house', translated_text: 'д',
      #                      user_id: 1, block_id: 1)
      #   check_result = card.check_translation('RoR')
      #   expect(check_result[:state]).to be false
      # end
  end

  describe "#check translation sets correct card attributes" do
    before do
      card.save
    end

    def check_translation(translation, attempt=1)
      attempt.times do
        card.check_translation(translation)
        card.reload
      end
    end

    def expect_parameters(parameters={})
      parameters.each_pair do |key, value|
        expect(card[key]).to eq(value)
      end
    end

    context 'with correct translation' do
      
      describe 'when interval: 1, repeat: 1, efactor: 2.5, quality: 5' do
        before(:each) do
          card.update_attributes(interval: 1, repeat: 1, efactor: 2.5, quality: 5)
        end

        it 'set correct review date, interval, repeat and attempt for repeat=1 quality=5' do
          check_translation('house')
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 6, repeat: 2, attempt: 1
        end

        it 'repeat=1 quality=5' do
          check_translation('house')
          expect_parameters efactor: 2.6, quality: 5
        end

        it 'repeat=1 quality=4' do
          check_translation('RoR')
          check_translation('house')
          expect_parameters efactor: 2.18, quality: 4
        end

        it 'repeat=1 quality=3' do
          check_translation('RoR', 2)
          check_translation('house')
          expect_parameters efactor: 1.5, quality: 3
        end

        it 'repeat=1 quality=3' do
          check_translation('RoR', 3)
          check_translation('house')
          expect_parameters efactor: 1.3, quality: 3
        end

        it 'repeat=1-3 quality=5' do
          check_translation('house', 3)
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 16.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 45, repeat: 4, attempt: 1, efactor: 2.8, quality: 5
        end
      end

      describe 'when interval: 6, repeat: 2, efactor: 2.6, quality: 5' do
        before(:each) do
          card.update_attributes(interval: 6, repeat: 2, efactor: 2.6, quality: 5)
        end
        it 'set correct review date, interval, repeat and attempt for repeat=2 quality=5' do
          check_translation('house')
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 6.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 16, repeat: 3, attempt: 1
        end

        it 'repeat=2 quality=5' do
          check_translation('house')
          expect_parameters efactor: 2.7, quality: 5
        end

        it 'repeat=2 quality=4' do
          check_translation('RoR')
          check_translation('house')
          expect_parameters efactor: 2.28, quality: 4
        end

        it 'repeat=2 quality=3' do
          check_translation('RoR', 2)
          check_translation('house')
          expect_parameters efactor: 1.6, quality: 3
        end

        it 'repeat=2 quality=3' do
          check_translation('RoR', 3)
          check_translation('house')
          expect_parameters efactor: 1.3, quality: 3
        end
      end

      describe 'when interval: 16, repeat: 3, efactor: 2.7, quality: 5' do
        before(:each) do
          card.update_attributes(interval: 16, repeat: 3, efactor: 2.7, quality: 5)
        end

        it 'set correct review date, interval, repeat and attempt for repeat=3 quality=5' do
          check_translation('house')
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 16.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 45, repeat: 4, attempt: 1
        end

        it 'repeat=3 quality=5' do
          check_translation('house')
          expect_parameters efactor: 2.8, quality: 5
        end

        it 'repeat=3 quality=4' do
          check_translation('RoR')
          check_translation('house')
          expect_parameters efactor: 2.38, quality: 4
        end

        it 'repeat=3 quality=3' do
          check_translation('RoR', 2)
          check_translation('house')
          expect_parameters efactor: 1.7, quality: 3
        end

        it 'repeat=3 quality=3' do
          check_translation('RoR', 3)
          check_translation('house')
          expect_parameters efactor: 1.3, quality: 3
        end
      end
    end

    context "when translation has a typo" do
      describe 'when interval: 1, repeat: 1, efactor: 2.5, quality: 4' do
        before do
          card.update_attributes(interval: 1, repeat: 1, efactor: 2.5, quality: 4)
        end

        it 'repeat=1-3 quality=4' do
          check_translation('house', 2)
          check_translation('RoR')
          check_translation('house')
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 6, repeat: 2, attempt: 1, efactor: 2.38, quality: 4
        end

        it 'repeat=1-3 quality=5' do
          check_translation('house')
          check_translation('RoR')
          check_translation('house', 2)
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 6.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 14, repeat: 3, attempt: 1, efactor: 2.38, quality: 5
        end

        it 'repeat=3 attempt=4' do
          check_translation('RoR', 3)
          check_translation('house')
          expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
              to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
          expect_parameters interval: 6, repeat: 2, attempt: 1, efactor: 1.3, quality: 3
        end
      end
    end

    context 'with incorrect translation' do
      describe 'when interval: 1, repeat: 1, efactor: 2.5, quality: 4' do
        before do
          card.update_attributes(interval: 1, repeat: 1, efactor: 2.5, quality: 4)
        end

        it 'repeat=1 attempt=1' do
          check_translation('RoR')
          expect_parameters interval: 1, repeat: 1, attempt: 2, efactor: 2.18, quality: 2
        end

        it 'repeat=1 attempt=2' do
          check_translation('RoR', 2)
          expect_parameters interval: 1, repeat: 1, attempt: 3, efactor: 1.64, quality: 1
        end

        it 'repeat=1 attempt=3' do
          check_translation('RoR', 3)
          expect_parameters interval: 1, repeat: 1, attempt: 4, efactor: 1.3, quality: 0
        end
      end
    end
  end
end