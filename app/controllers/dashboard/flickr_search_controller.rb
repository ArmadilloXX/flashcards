class Dashboard::FlickrSearchController < Dashboard::BaseController
  
  def search_photos
    @search_term = params[:search]
    if @search_term.blank?
      list = Flickrie.get_recent_photos per_page: 10
    else
      list = Flickrie.search_photos text: @search_term, per_page: 10
    end
    @photos = url_for_photos(list)
  end

  def url_for_photos(list)
    photos = []
    list.each do |photo|
      url = "https://farm#{photo.farm}.static.flickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_q.jpg"
      photos << url
    end
    photos
  end
end
