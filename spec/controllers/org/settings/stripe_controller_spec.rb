require 'spec_helper'

describe Org::Settings::StripeController do
  let(:organization) { create(:organization)}
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    StripeMock.start
    allow(controller).to receive(:current_organization).and_return( organization )
    sign_in user
  end

  after(:each) do
    StripeMock.stop
  end

  it 'should render show' do
    get :show, organization_id: organization
    expect(response).to be_success
  end
end