require 'spec_helper'

describe AuthenticationsController do
  let(:organization) { create(:organization) }
  let(:confirmed_user) { create(:confirmed_user, organization: organization)}

  before :each do
    allow(controller).to receive(:current_organization).and_return(organization)
    allow(organization).to receive(:apply_omniauth)
  end

  describe '#create' do
    context 'signed in' do
      before(:each) do
        sign_in confirmed_user
      end

      it 'should redirect to the organization view path if there is no redirect set' do
        get :create, provider: 'stripe'
        expect(response).to redirect_to(organization)
      end

      it 'should redirect to the a place specified in the session' do
        session['user_return_to'] = '/some/other/path'
        get :create, provider: 'stripe'
        expect(response).to redirect_to('/some/other/path')
      end
    end
  end
end