path = "#{Rails.root}/config/stripe.yml"
if File.exist? path
  Stripe.api_key = YAML::load(File.open(path))['STRIPE_SECRET']
else
  Stripe.api_key = ENV['STRIPE_SECRET']
end
