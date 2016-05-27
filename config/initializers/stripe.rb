StripeEvent.configure do |events|
  events.all StripeWebhook::Logger.new(Rails.logger)
  events.subscribe 'account.application.deauthorized', StripeWebhook::Deauthorized.new
end

Stripe.api_version = '2016-03-07'
Stripe.api_key = ENV['STRIPE_SECRET']
