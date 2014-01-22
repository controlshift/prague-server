require 'spec_helper'

describe OrganizationStripeInformationWorker do
  let(:organization) { create(:organization, email: nil) }

  describe '#perform' do

    before do
      Sidekiq::Testing.inline!
      Organization.any_instance.stub(:update_account_information_from_stripe!)
      StripeMock.start
    end

    specify 'it should grab information from the account by id' do
      expect {
        OrganizationStripeInformationWorker.perform_async(organization.id)
        organization.reload
      }.to change(organization, :email).from(nil)
    end

  end
end
