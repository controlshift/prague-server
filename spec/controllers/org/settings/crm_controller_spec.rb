require 'spec_helper'

describe Org::Settings::CrmController do
  let(:organization) { create(:organization)}
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in user
  end

  it 'should render new' do
    xhr :get, :new, organization_id: organization, crm: {platform: 'actionkit'}
    expect(response).to be_success
    expect(assigns(:crm)).to_not be_nil
  end

  it 'should render edit' do
    xhr :get, :edit, organization_id: organization
    expect(response).to be_success
  end

  it 'should render show' do
    xhr :get, :show, organization_id: organization
    expect(response).to be_success
  end
end