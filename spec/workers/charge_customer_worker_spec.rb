require 'spec_helper'

describe ChargeCustomerWorker do
  let(:charge) { create(:charge, customer: create(:customer), organization: create(:organization))}
  describe '#perform' do
    before do
      charge
      Sidekiq::Testing.inline!
      StripeMock.start
      Stripe::StripeObject.any_instance.stub(:id).and_return('tok_test')
    end

    specify 'it should request a charge from Stripe and push success' do
      Stripe::Charge.should_receive(:create)
      Pusher::Channel.any_instance.should_receive(:trigger).with('charge_completed', { status: 'success' })
      CrmNotificationWorker.should_receive(:perform_async)
      ChargeCustomerWorker.perform_async(charge.id)
    end

    specify 'it should push failure on card declined' do
      StripeMock.prepare_card_error(:card_declined)
      Pusher::Channel.any_instance.should_receive(:trigger).with('charge_completed', 
        { 
          status: 'failure',
          message: 'The card was declined'
        })
      ChargeCustomerWorker.perform_async(charge.id)
    end

    specify 'it should push failure on something else going wrong with Stripe' do
      StripeMock.prepare_error(Stripe::StripeError.new, :new_charge)
      Pusher::Channel.any_instance.should_receive(:trigger).with('charge_completed', 
        { 
          status: 'failure',
          message: 'Something went wrong, please try again.'
        })
      expect { ChargeCustomerWorker.perform_async(charge.id) }.to raise_error
    end
  end
end
