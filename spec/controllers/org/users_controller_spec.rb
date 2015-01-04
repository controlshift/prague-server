require 'spec_helper'

describe Org::UsersController do
  let(:organization) { create(:organization) }
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'index' do
    it 'should successfully load' do
      get :index, organization_id: organization.id
      expect(response).to be_success
    end
  end

  describe 'destroy' do
    let(:other_user) { create(:confirmed_user, organization: organization) }

    it 'should be possible to destroy another user' do
      delete :destroy, organization_id: organization, id: other_user
      expect(response).to be_redirect
      expect(assigns(:user).frozen?).to be_true
    end

    it 'should not be possible to delete the currently signed in user' do
      delete :destroy, organization_id: organization, id: user
      expect(response).to be_redirect
      expect(assigns(:user).frozen?).to be_false
    end
  end
end