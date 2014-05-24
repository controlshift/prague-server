StripeEvent.configure do |events|
  events.all StripeWebhook::Logger.new(Rails.logger)
  events.subscribe 'account.application.deauthorized', StripeWebhook::Deauthorized.new
end