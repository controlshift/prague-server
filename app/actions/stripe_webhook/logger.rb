module StripeWebhook
  class Logger
    def initialize(logger)
      @logger = logger
    end

    def call(event)
      @logger.debug "StripeWebhook: #{event.inspect}"
    end
  end
end