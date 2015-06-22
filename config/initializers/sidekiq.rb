require 'redis'

REDIS_URL = ENV['REDIS_PROVIDER'] || 'redis://localhost:6379'
REDIS_NAMESPACE = "prague-#{Rails.env}"

Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL, namespace: REDIS_NAMESPACE  }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => REDIS_URL, :namespace => REDIS_NAMESPACE }
end


module PragueServer
  class Application < Rails::Application
    def self.redis
      return @_redis if @_redis.present?
      @_redis = Redis.new(@_redis_config)
    end

    def self.redis_config= config
      @_redis_config = config
    end
  end
end

PragueServer::Application.redis_config= { :url => REDIS_URL, :namespace => REDIS_NAMESPACE }
