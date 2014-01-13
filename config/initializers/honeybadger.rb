if defined? Honeybadger
  unless ['development', 'test'].include? Rails.env
    Honeybadger.configure do |config|
      config.api_key = ENV['HONEYBADGER_API_KEY']
    end
  end
end
