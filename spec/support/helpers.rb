module HelperMethods
  def login
    OrganizationStripeInformationWorker.any_instance.stub(:perform)
    OmniAuth.config.mock_auth[:stripe_connect] = {
      'uid' => 'X',
      'info' => { 'stripe_publishable_key' => 'X' },
      'credentials' => { 'token' => 'X' }
    } 
    visit new_organization_path
    page.first('#stripe-connect-link').click
  end
end

RSpec.configure do |config|
  config.include HelperMethods
end