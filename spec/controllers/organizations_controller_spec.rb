require 'spec_helper'

describe OrganizationsController do
  describe 'POST create' do
    it 'creates an organization with omniauth credentials' do
      OmniAuth.config.mock_auth[:stripe_connect] = OmniAuth::AuthHash.new({
        'uid' => 'X',
        'info' => { 'stripe_publishable_key' => 'X' },
        'credentials' => { 'token' => 'X' }
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:stripe_connect] 

      post :create
      Organization.last.stripe_user_id.should == 'X'
      Organization.last.stripe_publishable_key.should == 'X'
    end
  end
end