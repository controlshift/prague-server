require 'spec_helper'

describe Org::Settings::Crm::ImportStubsController do
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    sign_in user
  end

  it 'should render new' do
    get :new, params: { organization_id: organization }, xhr: true
    expect(response).to be_success
    expect(assigns(:stub)).to_not be_nil
  end

  it 'should create a crm stub' do
    post :create, params: { organization_id: organization, import_stub: { donation_currency: 'usd', payment_account: 'foo' }}, xhr: true
    expect(response).to be_success
    expect(assigns(:stub)).to_not be_nil
  end

  it 'should destroy the stub' do
    import_stub = create(:import_stub, crm: crm)
    delete :destroy, params: { organization_id: organization, id: import_stub }, xhr: true
    expect(response).to be_success
    expect(assigns(:stub)).to eq(import_stub)
  end
end