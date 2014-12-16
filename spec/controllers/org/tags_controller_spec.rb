require 'spec_helper'

describe Org::TagsController do
  let!(:organization) { create(:organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}


  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'index' do
    it 'should render' do
      get :index, organization_id: organization
      response.should be_success
      assigns(:tags).should_not be_nil
    end
  end

  describe 'show' do
    it 'should render' do
      get :show, id: tag.name, organization_id: organization
      response.should be_success
      assigns(:tag).should eq(tag)
    end
  end
end