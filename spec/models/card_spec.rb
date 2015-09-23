require 'rails_helper'

describe Card do

  describe "create card" do
    context "with incorrect data" do
      it 'with empty original text' do
        card = Card.create(original_text: '', translated_text: 'house', user_id: 1,
                           block_id: 1)
        expect(card.errors[:original_text]).to include('Необходимо заполнить поле.')
      end

      it 'with empty translated text' do
        card = Card.create(original_text: 'дом', translated_text: '', user_id: 1,
                           block_id: 1)
        expect(card.errors[:translated_text]).
            to include('Необходимо заполнить поле.')
      end

      it 'with both empty texts' do
        card = Card.create(original_text: '', translated_text: '', user_id: 1,
                           block_id: 1)
        expect(card.errors[:original_text]).
            to include('Вводимые значения должны отличаться.')
      end

      it 'with equal_texts Eng' do
        card = Card.create(original_text: 'house', translated_text: 'house',
                           user_id: 1, block_id: 1)
        expect(card.errors[:original_text]).
            to include('Вводимые значения должны отличаться.')
      end

      it 'with equal_texts Rus' do
        card = Card.create(original_text: 'дом', translated_text: 'дом', user_id: 1,
                           block_id: 1)
        expect(card.errors[:original_text]).
            to include('Вводимые значения должны отличаться.')
      end

      it 'provides full_downcase Eng' do
        card = Card.create(original_text: 'hOuse', translated_text: 'houSe',
                           user_id: 1, block_id: 1)
        expect(card.errors[:original_text]).
            to include('Вводимые значения должны отличаться.')
      end

      it 'provides full_downcase Rus' do
        card = Card.create(original_text: 'Дом', translated_text: 'доМ', user_id: 1,
                           block_id: 1)
        expect(card.errors[:original_text]).
            to include('Вводимые значения должны отличаться.')
      end

      it 'without user_id' do
        card = Card.create(original_text: 'дом', translated_text: 'house',
                           block_id: 1)
        expect(card.errors[:user_id]).
            to include('Ошибка ассоциации.')
      end

      it 'without block_id' do
        card = Card.create(original_text: 'дом', translated_text: 'house',
                           user_id: 1)
        expect(card.errors[:block_id]).
            to include('Выберите колоду из выпадающего списка.')
      end
    end

    context 'with correct data' do
      let(:card) { Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1) }

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

  describe "check translation" do
    let(:card) { Card.create(original_text: 'дом', translated_text: 'house',
                         user_id: 1, block_id: 1)}

    context 'with correct translation' do
      let(:check_result) { card.check_translation('house') }

      before do
        check_result
      end

      it 'has state attribute equal to true' do
        expect(check_result[:state]).to be true
      end

      it 'has distance attribute equal to 0' do
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

    context "when translation has a typo" do
      let(:check_result) { card.check_translation('hous') }

      before do
        check_result
      end

      it 'has state attribute equal to true' do
        expect(check_result[:state]).to be true
      end

      it 'has distance attribute equal to 1' do
        expect(check_result[:distance]).to eq(1)
      end

    end

    context 'with incorrect translation' do
      it 'has state attribute equal to false' do
        check_result = card.check_translation('RoR')
        expect(check_result[:state]).to be false
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
  end
end