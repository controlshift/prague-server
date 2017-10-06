require 'spec_helper'

describe ChargeCustomerWorker do
  let(:organization) { create(:organization) }
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 1984) }
  let(:stripe_customer) { Stripe::Customer.create(source: card_token) }
  let(:customer) { create(:customer, customer_token: stripe_customer.id) }
  let(:charge) { create(:charge, customer: customer, organization: organization, card: nil)}
  let(:pusher_channel) { double }

  describe '#perform' do
    before do
      Sidekiq::Testing.inline!
      StripeMock.start
      allow(Pusher).to receive(:[]).with(charge.pusher_channel_token).and_return(pusher_channel)
    end

    after do
      StripeMock.stop
    end

    specify 'it should request a charge from Stripe and push success' do
      expect(pusher_channel).to receive(:trigger).with('charge_completed', { status: 'success' })
      expect(CrmNotificationWorker).to receive(:perform_async)

      ChargeCustomerWorker.perform_async(charge.id)
      charge.reload

      expect(charge.paid?).to be_truthy
      expect(charge.id).not_to be_nil
      expect(charge.card).not_to be_nil
      expect(charge.card['type']).to eq('Visa')
    end

    specify 'it should push failure on card declined' do
      StripeMock.prepare_card_error(:card_declined)
      expect(pusher_channel).to receive(:trigger).with('charge_completed',
                                                       {
                                                         status: 'failure',
                                                         message: 'The card was declined'
                                                       })

      ChargeCustomerWorker.perform_async(charge.id)
      expect(charge.log_entries.last.message).to eq('Unsuccessful charge: The card was declined')
    end

    specify 'it should push failure on something internal going wrong with Stripe' do
      StripeMock.prepare_error(Stripe::StripeError.new, :new_charge)
      expect(pusher_channel).to receive(:trigger).with('charge_completed',
                                                       {
                                                         status: 'failure',
                                                         message: 'Something went wrong, please try again.'
                                                       })
      expect { ChargeCustomerWorker.perform_async(charge.id) }.to_not raise_error
    end

    specify 'it should push failure on something else going wrong with Stripe' do
      allow(Stripe::Charge).to receive(:create).and_raise(StandardError.new("Blahblah"))
      expect(pusher_channel).to receive(:trigger).with('charge_completed',
                                                       {
                                                         status: 'failure',
                                                         message: 'Something went wrong, please try again.'
                                                       })
      expect { ChargeCustomerWorker.perform_async(charge.id) }.to_not raise_error
      expect(charge.log_entries.last.message).to eq('Unknown error: Blahblah')
    end

    context 'without a token' do
      let(:organization) { create(:organization, access_token: '') }


      it 'should return an error mesasge' do
        expect(pusher_channel).to receive(:trigger).with('charge_completed',
                                                         {
                                                           status: 'failure',
                                                           message: "#{organization.name} has not been connected to Stripe."
                                                         })
        ChargeCustomerWorker.perform_async(charge.id)
      end
    end
  end
end
