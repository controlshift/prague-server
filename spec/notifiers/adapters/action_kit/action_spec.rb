require 'spec_helper'

describe Adapters::ActionKit::Action do

  describe '#to_hash' do
    let!(:crm) { create(:crm, organization: organization, default_currency: 'usd') }
    let(:import_stub) { create(:import_stub, crm: crm, donation_currency: 'gbp')}
    let(:organization) { create(:organization)}
    let(:charge) { create(:charge, currency: 'gbp', organization: organization, config: {rates: "{\"GBP\"=>2, \"JPY\"=>101.7245, \"USD\"=>1}", 'action_foo' => 'bar', 'a' => 'b', 'akid' => 'XXX'}) }

    subject { Adapters::ActionKit::Action.new charge: charge, import_stub: import_stub }

    it 'should generate a hash' do
      expect(subject.to_hash).to be_a(Hash)
    end

    it 'should not normalize to USD if there is an import_stub' do
      expect(subject.to_hash[:amount_other]).to eq('10.00')
    end

    context 'without import stub' do
      subject { Adapters::ActionKit::Action.new(charge: charge, import_stub: nil) }

      it 'should normalize to USD if there is no matching import stub' do
        expect(subject.to_hash[:amount_other]).to eq('5.00')
      end
    end
  end

  describe '#config_hash' do
    let(:charge) { build(:charge, config: {'action_foo' => 'bar', 'a' => 'b', 'akid' => 'XXX'}) }
    subject { Adapters::ActionKit::Action.new charge: charge }

    it 'should only return the key value pairs where the key starts with action_' do
      expect(subject.send(:config_hash)).to eq({'action_foo' => 'bar', 'orig_akid' => 'XXX'})
    end
  end
end