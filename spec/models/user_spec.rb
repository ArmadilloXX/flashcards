require "rails_helper"

describe User do
  describe "#card_for_review" do
    let(:user) { create(:user) }
    let(:block1) { create(:block, user: user) }
    let(:block2) { create(:block, user: user) }
    let!(:card1) { create(:card, user: user, block: block1) }
    let!(:card2) { create(:card, user: user, block: block2) }

    context "when user has current block" do
      before { user.update(current_block: block1) }

      it "returns card only from current block" do
        expect(user.card_for_review).to eq(card1)
      end
    end
  end
end
