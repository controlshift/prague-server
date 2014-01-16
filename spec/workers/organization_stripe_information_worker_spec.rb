require 'spec_helper'

describe OrganizationStripeInformationWorker do
  let(:organization) { create(:organization) }
  let(:account) { Stripe::Account.new }

  describe '#perform' do

    before do
      Sidekiq::Testing.inline!
      account.name = 'Foo'
      Stripe::Account.stub(:retrieve).and_return(account)
    end

    specify 'it should update the organization name' do
      expect {
        OrganizationStripeInformationWorker.perform_async(organization.id)
        organization.reload
      }.to change(organization, :name).to('Foo')
    end
  end
end