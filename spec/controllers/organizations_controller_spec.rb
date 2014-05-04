require 'spec_helper'

describe OrganizationsController do
  before(:each) do |example|
    Organization.last.try :destroy
    Crm.last.try :destroy
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
  end
end
