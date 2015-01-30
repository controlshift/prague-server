require 'spec_helper'

describe CreateCustomerTokenWorker do

  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 2015) }
  let(:charge) { build(:charge) }
  let(:customer) { create(:customer, customer_token: nil, charges: [ charge ] ) }

  describe '#perform' do
    before do
      Sidekiq::Testing.inline!
      StripeMock.start
    end

    specify 'it should update customer with a token' do
      allow(ChargeCustomerWorker).to receive(:perform_async)
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
      customer.reload
      expect(customer.customer_token).to match(/cus_.*/)
    end

    specify 'it should kick off ChargeCustomerWorker on a success' do
      expect(ChargeCustomerWorker).to receive(:perform_async)
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
    end

    specify 'it should update the token if it already has a customer token from a previous donation' do
      allow(ChargeCustomerWorker).to receive(:perform_async)
      customer.customer_token = 'i_donated_before'
      customer.save!
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
      customer.reload
      expect(customer.customer_token).to match(/cus_.*/)
    end

    specify 'it should succeed and kick off ChargeCustomerWorker for a repeat donater' do
      expect(ChargeCustomerWorker).to receive(:perform_async)
      customer.customer_token = 'cus_i_donated_before'
      customer.save!
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
    end

    specify 'it should push failure on something else going wrong with Stripe' do
      allow(Stripe::Customer).to receive(:create).and_raise(StandardError.new("Blahblah"))
      expect_any_instance_of(Pusher::Channel).to receive(:trigger).with('charge_completed',
        {
          status: 'failure',
          message: 'Blahblah'
        })
      expect { CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id) }.to_not raise_error
    end

    specify 'it should not kick off ChargeCustomerWorker if customer creation fails' do
      allow_any_instance_of(Pusher::Channel).to receive(:trigger)
      StripeMock.prepare_error(StandardError.new('something went wrong!'), :new_customer)
      expect(ChargeCustomerWorker).not_to receive(:perform_async)
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, charge.id)
    end
  end
end
