require "rails_helper"

describe AddCardsFromUrlJob do
  WebMock.allow_net_connect!
  let!(:user) { create(:user, locale: "ru") }
  let!(:block) { create(:block, title: "TestBlock", user: user) }
  let(:correct_params) do
    {
      url: "http://www.learnathome.ru/blog/100-beautiful-words",
      original_selector: "table tr td:nth-child(2) p",
      translated_selector: "table tr td:first-child p",
      block_id: block.id,
      user_id: user.id
    }
  end
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
