CONF = YAML::load(File.open("#{Rails.root}/config/stripe.yml"))

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stripe_connect, CONF['STRIPE_CONNECT_CLIENT_ID'], CONF['STRIPE_SECRET'], scope: 'read_write'
end