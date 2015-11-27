require "rails_helper"
require "pusher"

describe CardsBatchImporter do
  WebMock.allow_net_connect!
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, title: "TestBlock", user: user) }
  let(:correct_params) do
    {
      url: "http://www.learnathome.ru/blog/100-beautiful-words", # Contains 70 pairs of words
      original_selector: "table tr td:nth-child(2) p",
      translated_selector: "table tr td:first-child p",
      block_id: block.id,
      user_id: user.id
    }
  end
  let(:incorrect_params) do
    {
      url: "http://www.learnathome.ru/blog/100-beautiful-words", # Contains 70 pairs of words
      original_selector: "orig",
      translated_selector: "trans",
      block_id: block.id,
      user_id: user.id
    }
  end

  describe "start" do
    let(:start_job) { AddCardsFromUrlJob.perform_now correct_params }

    it "receives #start message when job created" do
      expect_any_instance_of(CardsBatchImporter).to receive(:start)
      start_job
    end

    it "receives #notify message when job finished" do
      expect_any_instance_of(CardsBatchImporter).to receive(:notify)
      start_job
    end
  end

  context 'when correct params' do
    let(:start_job) { AddCardsFromUrlJob.perform_now correct_params }

    it "creates cards" do
      start_job
      expect(block.cards.count).to eq(70)
    end

    it "finishes with success result" do
      start_job
      expect(result[:status]).to eq("success")
    end
  end

  context 'when incorrect params' do
    let(:start_job) { AddCardsFromUrlJob.perform_now incorrect_params }

    it "does not creates cards" do
      start_job
      expect(block.cards.count).to eq(0)
    end
  end
end
