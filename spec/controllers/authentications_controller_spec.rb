require 'spec_helper'

describe AuthenticationsController do
  let(:organization) { create(:organization) }

  before :each do
    controller.stub(:current_organization).and_return(organization)
    organization.stub(:apply_omniauth)
  end
  describe '#create' do
    it 'should redirect to the organization view path if there is no redirect set' do
      get :create, provider: 'stripe'
      expect(response).to redirect_to(organization)
    end

    it 'should redirect to the a place specified in the session' do
      session['organization_return_to'] = '/some/other/path'
      get :create, provider: 'stripe'
      expect(response).to redirect_to('/some/other/path')
    end
  end
end