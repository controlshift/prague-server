require 'spec_helper'

describe MarkChargeAsPaidService do
  let(:charge) { create(:charge, card: nil, paid: false)}
  let(:stripe_charge) { { id: 1, card: JSON.parse('{"test": "test"}') }}

    describe '#call' do
    before(:each) { MarkChargeAsPaidService.new(charge, stripe_charge).call }

    it 'sets charge.paid to be true' do
      expect(charge.paid).to eq(true)
    end

    it 'updates charge id' do
      expect(charge.stripe_id).to eq(1)
    end

    it 'updates charge card' do
      expect(charge.card).to eq(stripe_charge[:card].to_hash)
    end

    it 'creates new log entry for charge' do
      expect(charge.log_entries.last.message).to eq('Successful charge.')
    end
  end
end
