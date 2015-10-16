module FlickrHelper

  def stub_flickr_requests

    recent_response = { "photos": 
      { "page": 1, "pages": 100, "perpage": 10, "total": "1000",
        "photo": [
            { "id": "22026223630", "media": "photo", "owner": "56956901@N05", "secret": "ed93e74060", "server": "600", "farm": 1, "title": "Boat ride on the bund #shanghai #china #bund #onlyinshanghai #boat #lights #ledscreens #ledstripes #colorful #electric #hdr #unique #anitalianpointofview", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
            { "id": "22224646391", "media": "photo", "owner": "75547855@N00", "secret": "edf901d271", "server": "5801", "farm": 6, "title": "DSC_0468", "ispublic": 1, "isfriend": 0, "isfamily": 0 }
          ]}, "stat": "ok" }.to_json


    search_response = { "photos":
      { "page": 1, "pages": "34959", "perpage": 10, "total": "349585",
        "photo": [
            { "id": "22026530338", "media": "photo", "owner": "136133610@N05", "secret": "2a5a113e0e", "server": "612", "farm": 1, "title": "books and coffee, is there a better match? #bonneadresse #cafeparis", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
            { "id": "22027077879", "media": "photo", "owner": "126066342@N03", "secret": "4214790554", "server": "5639", "farm": 6, "title": "Coffee for two", "ispublic": 1, "isfriend": 0, "isfamily": 0 }
          ]}, "stat": "ok" }.to_json

    @recent = [
        "https://farm1.static.flickr.com/600/22026223630_ed93e74060_q.jpg",
        "https://farm6.static.flickr.com/5801/22224646391_edf901d271_q.jpg"
      ]

    @search_result = [
        "https://farm1.static.flickr.com/612/22026530338_2a5a113e0e_q.jpg",
        "https://farm6.static.flickr.com/5639/22027077879_4214790554_q.jpg"
      ]

    stub_request(:get, "https://api.flickr.com/services/rest?api_key=b6371db92a0a0332eccddbf0897cb935&extras=media&format=json&method=flickr.photos.getRecent&nojsoncallback=1&per_page=10").
             to_return(:status => 200, :body => "#{recent_response}", :headers => {})
    stub_request(:get, "https://api.flickr.com/services/rest?api_key=b6371db92a0a0332eccddbf0897cb935&extras=media&format=json&media=photos&method=flickr.photos.search&nojsoncallback=1&per_page=10&text=coffee").
      to_return(:status => 200, :body => "#{search_response}", :headers => {})
  end

end