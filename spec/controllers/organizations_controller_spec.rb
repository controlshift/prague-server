require 'spec_helper'

describe OrganizationsController do
  before(:each) do |example|
    Organization.last.try :destroy
    Crm.last.try :destroy
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
  end
  describe 'POST create' do
    let(:auth_hash_hash) { OmniAuth::AuthHash.new(auth_hash) }

    context 'organization does not exist' do

      before(:each) do
        OmniAuth.config.mock_auth[:stripe_connect] = auth_hash_hash
        request.env["omniauth.auth"] = auth_hash
        StripeMock.start
      end

      context 'with credentials' do
        let(:auth_hash) { {
          'uid' => 'X',
          'info' => { 'stripe_publishable_key' => 'X' },
          'credentials' => { 'token' => 'X' }
        } }

        it 'creates an organization' do
          OrganizationStripeInformationWorker.any_instance.should_receive(:perform)
          
          post :create

          OmniAuth.config.mock_auth[:stripe_connect] = OmniAuth::AuthHash.new()
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:stripe_connect]

          expect(response).to redirect_to(assigns(:organization))
          assigns(:organization).stripe_user_id.should == 'X'
          assigns(:organization).stripe_publishable_key.should == 'X'
          subject.current_organization.should == Organization.last
        end
      end

      context 'without credentials' do
        let(:auth_hash) { {} }

        it 'renders new if something goes wrong with creating an organization' do
          post :create
          expect(response).to render_template("new")
        end
      end
    end

    context 'organization does exist' do

      before(:each) do
        OmniAuth.config.mock_auth[:stripe_connect] = auth_hash_hash
        request.env["omniauth.auth"] = auth_hash
      end

      let(:auth_hash) { {
          'uid' => 'X',
          'info' => { 'stripe_publishable_key' => 'X' },
          'credentials' => { 'token' => 'X' }
        } }

      it 'signs an organization in and redirects' do
        organization = create(:organization, stripe_publishable_key: 'X', stripe_user_id: 'X', access_token: 'X')
        amount_of_organizations_before = Organization.all.length

        post :create

        subject.current_organization.should == organization
        amount_of_organizations_before.should == Organization.all.length
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
    let(:organization) {create(:organization, global_defaults: { currency: 'AUD' }) }

    before(:each) do 
      sign_in organization
    end

    it 'should show an organization' do
      get :show, id: organization 
      expect(response).to render_template(:show)
    end

    it 'should respond with default settings for JSON request' do
      get :show, id: organization, format: :json
      response.body.should == organization.global_defaults.merge(rates: { 'GBP' => 1.1234}).to_json
    end
  end
end
