require "rails_helper"

describe Dashboard::BlocksController do
  let!(:user) { create(:user) }
  let!(:register) { @controller.send(:auto_login, user) }
  let!(:block) { create(:block, user: user) }

  describe "PUT #set_as_current" do
    before { put :set_as_current, id: block.id }
    it { is_expected.to redirect_to :blocks }
    it "sets block as current block for user" do
      expect(user.current_block).to eq(block)
    end
  end

  describe "PUT #reset_as_current" do
    before { put :reset_as_current, id: block.id }
    it { is_expected.to redirect_to :blocks }
    it "reset current block for user" do
      expect(user.current_block).to be_nil
    end
  end
end
