require 'spec_helper'

describe OrganizationsController do
  let(:organization) {create(:organization, global_defaults: { currency: 'AUD' }) }

  before(:each) do
    Organization.last.try :destroy
    Crm.last.try :destroy
    sign_in organization
  end

  describe 'GET show' do
    before(:each) do
      StripeMock.start
      get :show, id: organization
    end

    after(:each) { StripeMock.stop }

    it 'should show an organization' do
      expect(response).to render_template(:show)
    end
  end

  describe 'deauthorize' do
    let(:organization) { create(:organization, access_token: 'foo') }
    before(:each) do
      put :deauthorize, id: organization
    end

    it 'should show an organization' do
      expect(response).to redirect_to(organization)
      assigns(:organization).access_token.should be_nil
    end
  end
end
