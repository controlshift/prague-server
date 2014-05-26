Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stripe_connect, 
    ENV['STRIPE_CONNECT_CLIENT_ID'] || Rails.application.secrets.STRIPE_CONNECT_CLIENT_ID, 
    ENV['STRIPE_SECRET'] || Rails.application.secrets.STRIPE_SECRET, scope: 'read_write'
end

OmniAuth.config.on_failure = Proc.new do |env|
  OrganizationsController.action(:omniauth_failure).call(env)
end