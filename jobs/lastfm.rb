require 'json'

username = ENV['LASTFM_USER']
api_key = ENV['LASTFM_API_KEY']

SCHEDULER.every '5s', :first_in => 0 do |job|
  begin 
    http = Net::HTTP.new('ws.audioscrobbler.com')
    response = http.request(Net::HTTP::Get.new("/2.0/?method=user.getrecenttracks&user=#{username}&api_key=#{api_key}&format=json"))
    track = JSON.parse(response.body)['recenttracks']['track'][0]

    send_event('lastfm', { :cover => track['image'][2]['#text'], :artist => track['artist']['#text'], :track => track['name']})
  rescue Exception => e
    puts "Last.fm error: #{e.message}"
  end
end
