Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDIS_PROVIDER'] || 'redis://localhost:6379', :namespace => "prague-#{Rails.env}" }
end
