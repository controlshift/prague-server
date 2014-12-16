require 'spec_helper'

describe Org::ChargesController do
  describe 'index' do
    let(:organization) { create(:organization) }
    let(:user) { create(:confirmed_user, organization: organization)}

    before(:each) do
      controller.stub(:current_organization).and_return( organization )
      sign_in user
      get :index, organization_id: organization
    end

    it 'should return a list of charges' do
      assigns(:charges).should be_empty
    end

    context 'with a charge in the organization' do
      let!(:charge) { create(:charge, organization: organization) }

      it 'should return a list of charges' do
        assigns(:charges).should == [charge]
      end
    end
  end
end