require 'spec_helper'

describe Org::Tags::ChargesController do
  let(:organization) { create(:organization)}
  let(:tag) { create(:tag, name: 'foo', organization: organization) }
  let(:charge) { create(:charge, tag: tag, organization: organization) }
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  it 'should get index' do
    get :index, params: { tag_id: tag, organization_id: organization }, format: 'csv'

    expect(response).to be_success
  end
end