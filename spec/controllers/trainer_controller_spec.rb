require 'rails_helper'
require 'support/helpers/trainer_helper.rb'
include TrainerHelper

describe Dashboard::TrainerController do
  let(:user)  { create(:user) }
  let(:register) { @controller.send(:auto_login, user) }
  let(:block) { create(:block, user: user) }
  let(:card)  { create(:card, user: user,
                              block: block,
                              interval: 1, 
                              repeat: 1, 
                              efactor: 2.5, 
                              quality: 5)}

  shared_examples 'login denied' do
    it { is_expected.to redirect_to :login }
    it { is_expected.to set_flash[:alert] }
  end

  describe "GET index" do
    context 'when user not authorized' do
      before do
        get :index
      end
      it_behaves_like 'login denied'
    end

    context "when user authorized" do
      before do
        register
        get :index
      end
      it { is_expected.to render_template 'index' }
    end

    context "when params[:id] presented(redirect from review_card)" do
      before do
        register
        get :index, id: card.id
      end
      it 'assigns the card' do
        expect(assigns(:card)).to eq(card)
      end
    end
  end

  describe "PUT review_card" do
    context 'when user not authorized' do
      before do 
        put :review_card
      end
      it_behaves_like 'login denied'
    end

    context 'when user authorized' do
      before do
        register
      end

      describe "when translation successful" do
        before do
          check_review_card(card, 'house', 1)
        end
        it { is_expected.to set_flash[:notice] }
        it { is_expected.to redirect_to trainer_path }
      end

      describe "when user made typo in translation" do
        before do
          check_review_card(card, 'hous', 1)
        end
        it { is_expected.to set_flash[:alert] }
        it { is_expected.to redirect_to trainer_path }
      end

      describe "when translation incorrect" do
        before do
          check_review_card(card, 'RoR', 1)
        end
        it { is_expected.to set_flash[:alert] }
        it { is_expected.to redirect_to trainer_path(id: card.id)}
      end
    end
  end

  # describe 'review_card' do
  #   describe 'correct translation' do
  #     before do
  #       @user = create(:user)
  #       @block = create(:block, user: @user)
  #       @controller.send(:auto_login, @user)
  #     end

  #     it 'repeat=1 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
  #           to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
  #       expect(card.interval).to eq(6)
  #       expect(card.repeat).to eq(2)
  #       expect(card.attempt).to eq(1)
  #     end

  #     it 'repeat=1 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.6)
  #       expect(card.quality).to eq(5)
  #     end

  #     it 'repeat=1 quality=4' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'RoR', 1)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.18)
  #       expect(card.quality).to eq(4)
  #     end

  #     it 'repeat=1 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'RoR', 2)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.5)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=1 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'RoR', 3)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.3)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=2 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 6, repeat: 2, efactor: 2.6, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
  #           to eq((Time.zone.now + 6.days).strftime('%Y-%m-%d %H:%M'))
  #       expect(card.interval).to eq(16)
  #       expect(card.repeat).to eq(3)
  #       expect(card.attempt).to eq(1)
  #     end

  #     it 'repeat=2 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 6, repeat: 2, efactor: 2.6, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.7)
  #       expect(card.quality).to eq(5)
  #     end

  #     it 'repeat=2 quality=4' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 6, repeat: 2, efactor: 2.6, quality: 5)
  #       card = check_review_card(card, 'RoR', 1)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.28)
  #       expect(card.quality).to eq(4)
  #     end

  #     it 'repeat=2 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 6, repeat: 2, efactor: 2.6, quality: 5)
  #       card = check_review_card(card, 'RoR', 2)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.6)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=2 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 6, repeat: 2, efactor: 2.6, quality: 5)
  #       card = check_review_card(card, 'RoR', 3)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.3)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=3 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 16, repeat: 3, efactor: 2.7, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
  #           to eq((Time.zone.now + 16.days).strftime('%Y-%m-%d %H:%M'))
  #       expect(card.interval).to eq(45)
  #       expect(card.repeat).to eq(4)
  #       expect(card.attempt).to eq(1)
  #     end

  #     it 'repeat=3 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 16, repeat: 3, efactor: 2.7, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.8)
  #       expect(card.quality).to eq(5)
  #     end

  #     it 'repeat=3 quality=4' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 16, repeat: 3, efactor: 2.7, quality: 5)
  #       card = check_review_card(card, 'RoR', 1)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(2.38)
  #       expect(card.quality).to eq(4)
  #     end

  #     it 'repeat=3 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 16, repeat: 3, efactor: 2.7, quality: 5)
  #       card = check_review_card(card, 'RoR', 2)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.7)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=3 quality=3' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 16, repeat: 3, efactor: 2.7, quality: 5)
  #       card = check_review_card(card, 'RoR', 3)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.efactor).to eq(1.3)
  #       expect(card.quality).to eq(3)
  #     end

  #     it 'repeat=1-3 quality=5' do
  #       card = create(:card, user: @user, block: @block,
  #                     interval: 1, repeat: 1, efactor: 2.5, quality: 5)
  #       card = check_review_card(card, 'house', 1)
  #       card.update(review_date: Time.zone.now)
  #       card = check_review_card(card, 'house', 1)
  #       card.update(review_date: Time.zone.now)
  #       card = check_review_card(card, 'house', 1)
  #       expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
  #           to eq((Time.zone.now + 16.days).strftime('%Y-%m-%d %H:%M'))
  #       expect(card.interval).to eq(45)
  #       expect(card.repeat).to eq(4)
  #       expect(card.attempt).to eq(1)
  #       expect(card.efactor).to eq(2.8)
  #       expect(card.quality).to eq(5)
  #     end
  #   end

    # describe 'incorrect translation' do
    #   before do
    #     @user = create(:user)
    #     @block = create(:block, user: @user)
    #     @controller.send(:auto_login, @user)
    #   end

    #   it 'repeat=1 attempt=1' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 1, repeat: 1, efactor: 2.5, quality: 4)
    #     card = check_review_card(card, 'RoR', 1)
    #     expect(card.interval).to eq(1)
    #     expect(card.repeat).to eq(1)
    #     expect(card.attempt).to eq(2)
    #     expect(card.efactor).to eq(2.18)
    #     expect(card.quality).to eq(2)
    #   end

    #   it 'repeat=1 attempt=2' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 1, repeat: 1, efactor: 2.5, quality: 4)
    #     card = check_review_card(card, 'RoR', 2)
    #     expect(card.interval).to eq(1)
    #     expect(card.repeat).to eq(1)
    #     expect(card.attempt).to eq(3)
    #     expect(card.efactor).to eq(1.64)
    #     expect(card.quality).to eq(1)
    #   end

    #   it 'repeat=1 attempt=3' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 1, repeat: 1, efactor: 2.5, quality: 4)
    #     card = check_review_card(card, 'RoR', 3)
    #     expect(card.interval).to eq(1)
    #     expect(card.repeat).to eq(1)
    #     expect(card.attempt).to eq(4)
    #     expect(card.efactor).to eq(1.3)
    #     expect(card.quality).to eq(0)
    #   end
    # end

    # describe 'correct and incorrect translation' do
    #   before do
    #     @user = create(:user)
    #     @block = create(:block, user: @user)
    #     @controller.send(:auto_login, @user)
    #   end

    #   it 'repeat=1-3 quality=4' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 1, repeat: 1, efactor: 2.5, quality: 4)
    #     card = check_review_card(card, 'house', 1)
    #     card.update(review_date: Time.zone.now)
    #     card = check_review_card(card, 'house', 1)
    #     card.update(review_date: Time.zone.now)
    #     card = check_review_card(card, 'RoR', 1)
    #     card = check_review_card(card, 'house', 1)
    #     expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
    #         to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
    #     expect(card.interval).to eq(6)
    #     expect(card.repeat).to eq(2)
    #     expect(card.attempt).to eq(1)
    #     expect(card.efactor).to eq(2.38)
    #     expect(card.quality).to eq(4)
    #   end

    #   it 'repeat=1-3 quality=5' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 1, repeat: 1, efactor: 2.5, quality: 4)
    #     card = check_review_card(card, 'house', 1)
    #     card.update(review_date: Time.zone.now)
    #     card = check_review_card(card, 'RoR', 1)
    #     card = check_review_card(card, 'house', 1)
    #     card.update(review_date: Time.zone.now)
    #     card = check_review_card(card, 'house', 1)
    #     expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
    #         to eq((Time.zone.now + 6.days).strftime('%Y-%m-%d %H:%M'))
    #     expect(card.interval).to eq(14)
    #     expect(card.repeat).to eq(3)
    #     expect(card.attempt).to eq(1)
    #     expect(card.efactor).to eq(2.38)
    #     expect(card.quality).to eq(5)
    #   end

    #   it 'repeat=3 attempt=4' do
    #     card = create(:card, user: @user, block: @block,
    #                   interval: 16, repeat: 3, efactor: 2.7, quality: 5)
    #     card = check_review_card(card, 'RoR', 3)
    #     card = check_review_card(card, 'house', 1)
    #     expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
    #         to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
    #     expect(card.interval).to eq(6)
    #     expect(card.repeat).to eq(2)
    #     expect(card.attempt).to eq(1)
    #     expect(card.efactor).to eq(1.3)
    #     expect(card.quality).to eq(3)
    #   end
    # end
  # end
end