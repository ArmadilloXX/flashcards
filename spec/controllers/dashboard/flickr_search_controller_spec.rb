require "rails_helper"

describe Dashboard::FlickrSearchController do
  let!(:user) { create(:user) }
  let!(:register) { @controller.send(:auto_login, user) }

  let(:photo_urls) do
    [
      "https://farm6.staticflickr.com/5742/21488769794_9fd96e7eb6_q.jpg",
      "https://farm1.staticflickr.com/601/21923710398_52b0732469_q.jpg",
      "https://farm1.staticflickr.com/705/21923710458_6fcb52ee05_q.jpg",
      "https://farm6.staticflickr.com/5727/22085412296_74760fb3f6_q.jpg",
      "https://farm1.staticflickr.com/688/22085412486_6a861b5e09_q.jpg",
      "https://farm1.staticflickr.com/618/22085412706_f3a85c67ef_q.jpg",
      "https://farm6.staticflickr.com/5724/22111607515_568962fa65_q.jpg",
      "https://farm1.staticflickr.com/585/22111607615_c35cff43db_q.jpg",
      "https://farm1.staticflickr.com/746/22111607905_cf03bc7571_q.jpg",
      "https://farm6.staticflickr.com/5760/22111608245_8886649659_q.jpg"
    ]
  end

  before do
    allow_any_instance_of(Dashboard::FlickrSearchController).to receive(:url_for_photos).with(any_args).and_return(photo_urls)
    Dashboard::FlickrSearchController.new.send(:url_for_photos, [1,2,3])
  end

  it "calls the Flickrie.get_recent_photos when no search params" do
    xhr :get, :search_photos, {search: '', format: 'js'}
    
    expect(assigns(:photos)).to eq(photo_urls)
  end
end
