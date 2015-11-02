module Dashboard
  class FlickrSearchController < Dashboard::BaseController
    respond_to :js

    def search_flickr
      @search_term = params[:search]
      list = if @search_term.blank?
               recent_photos
             else
               search_with
             end
      @photos = UrlHelper.url_for_photos(list)
    end

    private

    def recent_photos
      Flickrie.get_recent_photos per_page: 10
    end

    def search_with
      Flickrie.search_photos text: @search_term, per_page: 10
    end
  end
end
