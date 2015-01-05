require 'spec_helper'

describe Org::NamespacesController do
  let!(:organization) { create(:organization) }
  let!(:namespace) { create(:tag_namespace, namespace: 'bar', organization: organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization, namespace: namespace) }
  let!(:user) { create(:confirmed_user, organization: organization) }

  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'index' do
    it 'should render' do
      get :index, organization_id: organization
      assigns(:namespaces).should_not be_nil
      response.should be_success
    end
  end

  describe 'show' do
    it 'should render' do
      get :show, id: namespace.namespace, organization_id: organization
      assigns(:namespace).should eq(namespace)
    end
  end
end