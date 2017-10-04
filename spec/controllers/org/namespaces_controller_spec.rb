require 'spec_helper'

describe Org::NamespacesController do
  let!(:organization) { create(:organization) }
  let!(:namespace) { create(:tag_namespace, namespace: 'bar', organization: organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization, namespace: namespace) }
  let!(:user) { create(:confirmed_user, organization: organization) }

  before(:each) do
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'index' do
    it 'should render' do
      get :index, params: { organization_id: organization }
      expect(assigns(:namespaces)).not_to be_nil
      expect(response).to be_success
    end
  end

  describe 'show' do
    it 'should render' do
      get :show, params: { id: namespace.namespace, organization_id: organization }
      expect(assigns(:namespace)).to eq(namespace)
    end
  end
end