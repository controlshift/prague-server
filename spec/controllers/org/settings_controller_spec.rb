require 'spec_helper'

describe Org::SettingsController do
  describe 'show' do
    let(:organization) { create(:organization) }
    let(:user) { create(:confirmed_user, organization: organization)}

    before(:each) do
      allow(controller).to receive(:current_organization).and_return( organization )
      sign_in user
    end

    it 'should show the settings page' do
      get :show, organization_id: organization
      expect(response).to be_success
    end
  end
end