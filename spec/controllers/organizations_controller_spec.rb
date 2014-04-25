require 'spec_helper'

describe OrganizationsController do
  before(:each) do |example|
    Organization.last.try :destroy
    Crm.last.try :destroy
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
  end

  describe 'GET new' do
    before(:each) { get :new }

    it 'renders a new template for an Organization' do
      expect(response).to render_template("new")
    end
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
