path = "#{Rails.root}/config/stripe.yml"
if File.exist? path
  Stripe.api_key = YAML::load(File.open(path))['STRIPE_SECRET']
else
  Stripe.api_key = ENV['STRIPE_SECRET']
end

if Rails.env.test?
  Stripe.api_key = "sk_test_xxx"
end

StripeEvent.configure do |events|
  events.all StripeWebhook::Logger.new(Rails.logger)
  events.subscribe 'account.application.deauthorized', StripeWebhook::Deauthorized.new
end