require "rails_helper"
require "pusher"

describe CardsBatchImporter do
  WebMock.allow_net_connect!
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, title: "TestBlock", user: user) }
  let(:url) { "http://www.learnathome.ru/blog/100-beautiful-words" }
  let(:correct_params) do
    {
      url: url, # Contains 70 pairs of words
      original_selector: "table tr td:nth-child(2) p",
      translated_selector: "table tr td:first-child p",
      block_id: block.id,
      user_id: user.id
    }
  end
  let(:incorrect_params) do
    {
      url: url, # Contains 70 pairs of words
      original_selector: "orig",
      translated_selector: "trans",
      block_id: block.id,
      user_id: user.id
    }
  end
  let(:params_with_invalid_selectors) do
    {
      url: url, # Contains 70 pairs of words
      original_selector: "25.75",
      translated_selector: "trans",
      block_id: block.id,
      user_id: user.id
    }
  end
  context "when params are correct" do
    let(:importer) { CardsBatchImporter.new(correct_params) }

    before do
      importer.start
    end

    describe "#start method" do
      it "creates cards" do
        expect(block.cards.count).to eq(70)
      end

      it "sets a success result status" do
        expect(importer.result[:status]).to eq("success")
      end

      it "sets a successful result message" do
        expect(importer.result[:message]).to eq("70 cards were imported")
      end
    end

    describe "#notify method" do
      it "creates correct notification about success" do
        expect(Pusher).
          to receive(:trigger).with("bg-job-notifier-#{user.id}",
                                    "job_finished",
                                    type: "success",
                                    message: "70 cards were imported",
                                    url: url,
                                    cards_count: 70,
                                    block_id: block.id)
        importer.notify
      end
    end
  end

  shared_examples "not creates the cards and returns error" do
    it "does not creates cards" do
      expect(block.cards.count).to eq(0)
    end

    it "sets an error result status" do
      expect(importer.result[:status]).to eq("error")
    end

  end

  context "when params are incorrect" do
    let(:importer) { CardsBatchImporter.new(incorrect_params) }

    before do
      importer.start
    end

    describe "#start method" do
      it_behaves_like "not creates the cards and returns error"

      it "sets an result message about wrong selectors" do
        expect(importer.result[:message]).to eq("No cards were found for these selectors")
      end
    end

    describe "#notify method" do
      it "creates correct notification about error" do
        expect(Pusher).
          to receive(:trigger).with("bg-job-notifier-#{user.id}",
                                    "job_finished",
                                    type: "error",
                                    message: "No cards were found for these selectors",
                                    url: url,
                                    cards_count: 0,
                                    block_id: block.id)
        importer.notify
      end
    end
  end

  context "when selectors are invalid" do
    let(:importer) { CardsBatchImporter.new(params_with_invalid_selectors) }

    before do
      importer.start
    end

    describe "#start method" do
      it_behaves_like "not creates the cards and returns error"

      it "sets an result message about wrong selectors" do
        expect(importer.result[:message]).to eq("CSS selectors are not valid")
      end
    end

    describe "#notify method" do
      it "creates correct notification about error" do
        expect(Pusher).
          to receive(:trigger).with("bg-job-notifier-#{user.id}",
                                    "job_finished",
                                    type: "error",
                                    message: "CSS selectors are not valid",
                                    url: url,
                                    cards_count: 0,
                                    block_id: block.id)
        importer.notify
      end
    end
  end
end
