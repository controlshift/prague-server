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
      expect(response).to render_template("create")
      Organization.last.stripe_user_id.should == 'X'
      Organization.last.stripe_publishable_key.should == 'X'
    end

    it 'renders new if something goes wrong with creating an organization' do
      OmniAuth.config.mock_auth[:stripe_connect] = OmniAuth::AuthHash.new({})
      request.env["omniauth.auth"] = {}
      post :create
      expect(response).to render_template("new")
    end

    it 'renders new if some OmniAuth error is raised' do
      OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
      post :create
      expect(response).to render_template("new")
    end
  end

  describe 'GET new' do
    it 'renders a new template for an Organization' do
      get :new
      expect(response).to render_template("new")
    end
  end
end