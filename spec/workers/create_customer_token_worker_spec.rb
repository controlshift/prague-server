require 'spec_helper'

describe CreateCustomerTokenWorker do
  
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 2015) }
  let(:customer) { create(:customer, customer_token: nil, charges: [ build(:charge) ] ) }

  describe '#perform' do
    before do
      Sidekiq::Testing.inline!
      StripeMock.start
      ChargeCustomerWorker.should_receive(:perform_async)
    end

    specify 'it should update customer with a token and kick off a charge' do
      CreateCustomerTokenWorker.perform_async(customer.id, card_token)
      customer.reload
      customer.customer_token.should match(/cus_.*/)
    end

    specify 'it should kick off a charge if it already has a customer token' do
      CreateCustomerTokenWorker.perform_async(customer.id, card_token)
    end

    specify 'it should not actually create a customer if in testmode' do
      customer.charges.first.organization.update_attribute(:testmode, true)
      Stripe::Customer.should_not_receive(:create)
      CreateCustomerTokenWorker.perform_async(customer.id, card_token)
    end
  end
end
