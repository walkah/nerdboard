require 'instagram'

# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
end

# Instagram location ID
instagram_location_id = ENV['INSTAGRAM_LOCATION_ID']

SCHEDULER.every '10m', :first_in => 0 do |job|
  photos = Instagram.location_recent_media(instagram_location_id)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.standard_resolution.url}" }
    end
  end
  send_event('instagram', photos: photos)
end
