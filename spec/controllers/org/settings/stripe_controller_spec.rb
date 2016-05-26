require 'spec_helper'

describe Org::Settings::StripeController do
  let(:organization) { create(:organization, stripe_user_id: account.id)}
  let(:user) { create(:confirmed_user, organization: organization)}
  let(:account) { Stripe::Account.create }

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
