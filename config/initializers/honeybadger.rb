Honeybadger.configure do |config|
  config.api_key = Rails.env['HONEYBADGER_API_KEY']
end
