begin
  Stripe.api_key = YAML::load(File.open("#{Rails.root}/config/stripe.yml"))['STRIPE_SECRET']
rescue LoadError
  Stripe.api_key = ENV['STRIPE_SECRET']
end
