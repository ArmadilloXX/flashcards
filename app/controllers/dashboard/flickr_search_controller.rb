module Dashboard
  class FlickrSearchController < Dashboard::BaseController
    respond_to :js

    def search_flickr
      @search_term = params[:search]

      list = if @search_term.blank?
               # Rails.logger.warn("Search term is blank")
               recent_photos
             else
               # Rails.logger.warn("Search term provided")
               search_with
             end
      # Rails.logger.warn "++++++++++++++++++++++++++++++++"
      # Rails.logger.warn "list should be assigned"
      # Rails.logger.warn list.inspect
      @photos = url_for_photos(list)
      # Rails.logger.warn "++++++++++++++++++++++++++++++++"
      # Rails.logger.warn "@photos should be assigned"
      # Rails.logger.warn @photos.inspect
      # Rails.logger.warn "=================================="
      # Rails.logger.warn "Template should be rendered"
    end

    private

    def recent_photos
      Rails.logger.warn("Flickrie.get_recent_photos called")
      Flickrie.get_recent_photos per_page: 10
    end

    def search_with
      Rails.logger.warn("Flickrie.search_photos called")
      Flickrie.search_photos text: @search_term, per_page: 10
    end

    def url_for_photos(list)
      photos = []
      list.each do |photo|
        url = "https://farm#{photo.farm}.static.flickr.com/"\
        "#{photo.server}/#{photo.id}_#{photo.secret}_q.jpg"
        photos << url
      end
      photos
    end
  end
end
