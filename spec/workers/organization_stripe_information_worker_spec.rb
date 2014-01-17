require 'spec_helper'

describe OrganizationStripeInformationWorker do
  let(:organization) { create(:organization) }
  let(:account) { Stripe::Account.new }

  describe '#perform' do

    before do
      Sidekiq::Testing.inline!
      account.name = 'Foo'
      account.email = 'foo@bar.com'
      Stripe::Account.stub(:retrieve).and_return(account)
    end

    subject { -> { OrganizationStripeInformationWorker.perform_async(organization.id); organization.reload } }

    it { should change(organization, :name).to('Foo') }
    it { should change(organization, :email).to('foo@bar.com') }
  end
end
