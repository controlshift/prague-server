require 'spec_helper'

describe Org::Settings::Crm::ImportStubsController do
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    sign_in user
  end

  it 'should render new' do
    xhr :get, :new, organization_id: organization
    expect(response).to be_success
    expect(assigns(:stub)).to_not be_nil
  end

  it 'should create a crm stub' do
    xhr :post, :create, organization_id: organization, import_stub: { donation_currency: 'usd', payment_account: 'foo' }
    expect(response).to be_success
    expect(assigns(:stub)).to_not be_nil
  end

  it 'should destroy the stub' do
    import_stub = create(:import_stub, crm: crm)
    xhr :delete, :destroy, organization_id: organization, id: import_stub
    expect(response).to be_success
    expect(assigns(:stub)).to eq(import_stub)
  end
end