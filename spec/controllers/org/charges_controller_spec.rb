require 'spec_helper'

describe Org::ChargesController do
  describe 'index' do
    let(:organization) { create(:organization) }
    let(:user) { create(:confirmed_user, organization: organization)}

    before(:each) do
      allow(controller).to receive(:current_organization).and_return( organization )
      sign_in user
      get :index, params: { organization_id: organization }
    end

    it 'should return a list of charges' do
      expect(assigns(:charges)).to be_empty
    end

    context 'with a charge in the organization' do
      let!(:charge) { create(:charge, organization: organization) }

      it 'should return a list of charges' do
        expect(assigns(:charges)).to eq [charge]
      end
    end
  end
end