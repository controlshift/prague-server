require 'spec_helper'

describe Org::Namespaces::TagsController do
  let(:organization) { create(:organization)}
  let(:namespace) { create(:tag_namespace, organization: organization)}
  let(:tag) { create(:tag, name: 'foo', namespace: namespace, organization: organization) }
  let(:charge) { create(:charge, tag: tag, organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  it 'should get index' do
    get :index, namespace_id: namespace, organization_id: organization
    expect(response).to be_success
    expect(assigns(:tags)).to include(tag)
  end
end