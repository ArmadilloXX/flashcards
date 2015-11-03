module Dashboard
  class FlickrSearchController < Dashboard::BaseController
    respond_to :js

    def search
      @search_term = params[:search]
      list = if @search_term.blank?
                  Flickr.photos.get_recent(per_page: 10)
                else
                  Flickr.photos.search(text: @search_term, per_page: 10)
                end
      @photos = list.map { |photo| photo.square!(150).source_url }
    end
  end
end
