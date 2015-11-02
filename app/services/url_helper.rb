class UrlHelper
  class << self
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