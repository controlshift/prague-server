path = "#{Rails.root}/config/pusher.yml"
if File.exist? path
  config = YAML::load(File.open(path))
else
  config = ENV
end

Pusher.url = "http://#{config['PUSHER_KEY']}:#{config['PUSHER_SECRET']}@api.pusherapp.com/apps/#{config['PUSHER_APP_ID']}"
Pusher.logger = Rails.logger
