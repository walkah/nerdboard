require 'instagram'

# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
end

# Latitude, Longitude for location
instadash_location_lat = ENV['LOCATION_LAT']
instadash_location_long = ENV['LOCATION_LON']

SCHEDULER.every '10m', :first_in => 0 do |job|
  photos = Instagram.media_search(instadash_location_lat,instadash_location_long)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.standard_resolution.url}" }
    end    
  end
  send_event('instagram', photos: photos)
end
