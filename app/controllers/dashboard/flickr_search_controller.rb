class Dashboard::FlickrSearchController < Dashboard::BaseController
  def search_photos
    @search_term = params[:search]
    list = flickr.photos.search text: @search_term, per_page: 10
    puts list.inspect
    @photos = url_for_photos(list)
    puts @photos.class
  end

  private

  def url_for_photos(list)
    photos = []
    list.each do |photo|
      info = flickr.photos.getInfo(photo_id: photo["id"], secret: photo["secret"])
      photos << FlickRaw.url_q(info)
    end
    photos
  end
end
