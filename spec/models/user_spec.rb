require "rails_helper"

describe User do
  let(:user) { create(:user) }

  it "is not an admin when created" do
    expect(user.is_admin?).to be_falsy
  end

  describe "#cards_for_review" do
    let(:block1) { create(:block, user: user) }
    let(:block2) { create(:block, user: user) }
    let!(:card1) { create(:card, user: user, block: block1) }
    let!(:card2) { create(:card, user: user, block: block2) }

    it "returns collection of cards" do
      expect(user.cards_for_review).to be_a_kind_of ActiveRecord::AssociationRelation
    end

    context "when user has current block" do
      before { user.update(current_block: block1) }

      it "returns cards only from current block" do
        expect(user.cards_for_review).to include(card1)
      end
    end
  end
end
