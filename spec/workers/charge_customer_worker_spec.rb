require 'spec_helper'

describe ChargeCustomerWorker do
  let(:charge) { create(:charge, customer: create(:customer), organization: create(:organization))}
  describe '#perform' do
    before do
      charge
      Sidekiq::Testing.inline!
      StripeMock.start
    end

    specify 'it should request a charge from Stripe' do
      Stripe::Charge.should_receive(:create)
      ChargeCustomerWorker.perform_async(charge.id)
    end
  end
end