sk_url = ENV['REDIS_PROVIDER'] || 'redis://localhost:6379'
sk_namespace = "prague-#{Rails.env}"

Sidekiq.configure_server do |config|
  config.redis = { url: sk_url, namespace: sk_namespace  }
end

unless Rails.env.production? || Rails.env.staging?
  Sidekiq.configure_client do |config|
    config.redis = { size: 1, url: sk_url, namespace: sk_namespace  }
  end
end