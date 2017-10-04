require 'spec_helper'

describe Org::TagsController do
  let!(:organization) { create(:organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}


  before(:each) do
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'index' do
    it 'should render' do
      get :index, params: { organization_id: organization }

      expect(response).to be_success
      expect(assigns(:tags)).not_to be_nil
    end
  end

  describe 'show' do
    it 'should render' do
      get :show, params: { id: tag.name, organization_id: organization }

      expect(response).to be_success
      expect(assigns(:tag)).to eq(tag)
      expect(assigns(:charges)).to be_empty
    end
  end
end