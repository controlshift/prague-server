require 'spec_helper'

describe Org::TagsController do
  let!(:organization) { create(:organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization) }

  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in organization
  end

  describe 'index' do
    it 'should render' do
      get :index
      assigns(:tags).should_not be_nil
      response.should be_success
    end
  end

  describe 'show' do
    it 'should render' do
      get :show, id: tag.name
      assigns(:tag).should eq(tag)
    end
  end
end