require 'redis'

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
