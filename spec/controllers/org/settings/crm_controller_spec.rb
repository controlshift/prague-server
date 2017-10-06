require 'spec_helper'

describe Org::Settings::CrmController do
  let(:organization) { create(:organization)}
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  it 'should render new' do
    get :new, params: { organization_id: organization, crm: {platform: 'actionkit'} }, xhr: true
    expect(response).to be_success
    expect(assigns(:crm)).to_not be_nil
  end

  it 'should render edit' do
    get :edit, params: { organization_id: organization }, xhr: true
    expect(response).to be_success
  end

  it 'should render show' do
    get :show, params: { organization_id: organization }, xhr: true
    expect(response).to be_success
  end
end