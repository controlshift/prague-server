require 'spec_helper'

describe OrganizationsController do
  describe 'POST create' do
    let(:auth_hash_hash) { OmniAuth::AuthHash.new(auth_hash) }
    before(:each) do
      OmniAuth.config.mock_auth[:stripe_connect] = auth_hash_hash
      request.env["omniauth.auth"] = auth_hash
      post :create
    end

    context 'with credentials' do
      let(:auth_hash) { {
        'uid' => 'X',
        'info' => { 'stripe_publishable_key' => 'X' },
        'credentials' => { 'token' => 'X' }
      } }

      it 'creates an organization' do
        OmniAuth.config.mock_auth[:stripe_connect] = OmniAuth::AuthHash.new()
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:stripe_connect]

        expect(response).to redirect_to(assigns(:organization))
        assigns(:organization).stripe_user_id.should == 'X'
        assigns(:organization).stripe_publishable_key.should == 'X'
      end
    end

    context 'without credentials' do
      let(:auth_hash) { {} }

      it 'renders new if something goes wrong with creating an organization' do
        expect(response).to render_template("new")
      end

      it 'renders new if some OmniAuth error is raised' do
        OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
        visit "/auth/stripe_connect/callback"
        expect(response).to render_template("new")
      end
    end
  end

  describe 'GET new' do
    before(:each) { get :new }

    it 'renders a new template for an Organization' do
      expect(response).to render_template("new")
    end
    specify{ assigns(:organization).should_not be_nil}
  end

  describe 'GET show' do
    let(:organization) {create(:organization) }

    before(:each) { get :show, id: organization }

    it 'should show an organization' do
      expect(response).to render_template(:show)
    end

  end
end