sk_url = ENV['REDIS_PROVIDER'] || 'redis://localhost:6379'
sk_namespace = "prague-#{Rails.env}"

Sidekiq.configure_server do |config|
  config.redis = { url: sk_url, namespace: sk_namespace  }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_PROVIDER'] || 'redis://localhost:6379', :namespace => "prague-#{Rails.env}" }
end

unless Sidekiq::VERSION < '3'
  Sidekiq.configure_server do |config|
    config.error_handlers << Proc.new {|ex,context| Honeybadger.notify(ex, context: context) }
  end
end
