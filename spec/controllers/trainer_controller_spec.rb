require "rails_helper"
require "support/helpers/trainer_helper.rb"
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

  shared_examples "login denied" do
    it { is_expected.to redirect_to :login }
    it { is_expected.to set_flash[:alert] }
  end

  describe "GET index" do
    context "when user not authorized" do
      before do
        get :index
      end
      it_behaves_like "login denied"
    end

    context "when user authorized" do
      before do
        register
        get :index
      end
      it { is_expected.to render_template "index" }
    end

    context "when params[:id] presented(redirect from review_card)" do
      before do
        register
        get :index, id: card.id
      end
      it "assigns the card" do
        expect(assigns(:card)).to eq(card)
      end
    end
  end

  describe "PUT review_card" do
    context "when user not authorized" do
      before do 
        put :review_card
      end
      it_behaves_like "login denied"
    end

    context "when user authorized" do
      before do
        register
      end

      describe "when translation successful" do
        before do
          check_review_card(card, "house", 1)
        end
        it { is_expected.to set_flash[:notice] }
        it { is_expected.to redirect_to trainer_path }
      end

      describe "when user made typo in translation" do
        before do
          check_review_card(card, "hous", 1)
        end
        it { is_expected.to set_flash[:alert] }
        it { is_expected.to redirect_to trainer_path }
      end

      describe "when translation incorrect" do
        before do
          check_review_card(card, "RoR", 1)
        end
        it { is_expected.to set_flash[:alert] }
        it { is_expected.to redirect_to trainer_path(id: card.id)}
      end
    end
  end
end