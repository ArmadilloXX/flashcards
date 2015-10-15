class Dashboard::FlickrSearchController < Dashboard::BaseController
  respond_to :js

  def search_photos
    @search_term = params[:search]
    if @search_term.blank?
      Rails.logger.warn("when search is blank")
      list = Flickrie.get_recent_photos per_page: 10
    else
      Rails.logger.warn("when search provided")
      list = Flickrie.search_photos text: @search_term, per_page: 10
    end
    @photos = url_for_photos(list)
    Rails.logger.warn '++++++++++++++++++++++++++++++++'
    Rails.logger.warn @photos
  end

  private

  def url_for_photos(list)
    photos = []
    list.each do |photo|
      url = "https://farm#{photo.farm}.static.flickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_q.jpg"
      photos << url
    end
    photos
  end
end
