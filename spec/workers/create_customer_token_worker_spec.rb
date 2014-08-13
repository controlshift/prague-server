require 'spec_helper'

describe CreateCustomerTokenWorker do
  
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 2015) }
  let(:charge) { build(:charge) }
  let(:customer) { create(:customer, customer_token: nil, charges: [ charge ] ) }

  describe '#perform' do
    before do
      Sidekiq::Testing.inline!
      StripeMock.start
      ChargeCustomerWorker.stub(:perform_async)
    end

    specify 'it should update customer with a token and kick off a charge' do
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
      customer.reload
      customer.customer_token.should match(/cus_.*/)
    end

    specify 'it should kick off a charge if it already has a customer token' do
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
    end

    specify 'it should push failure on something else going wrong with Stripe' do
      Stripe::Customer.stub(:create).and_raise(StandardError.new("Blahblah"))
      Pusher::Channel.any_instance.should_receive(:trigger).with('charge_completed', 
        { 
          status: 'failure',
          message: 'Blahblah'
        })
      expect { CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id) }.to_not raise_error
    end
  end
end
