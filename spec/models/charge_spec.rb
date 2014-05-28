# == Schema Information
#
# Table name: charges
#
#  id                   :integer          not null, primary key
#  amount               :string(255)
#  currency             :string(255)
#  customer_id          :integer
#  organization_id      :integer
#  charged_back_at      :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  pusher_channel_token :string(255)
#  config               :hstore
#

require 'spec_helper'

describe Charge do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :currency }

  it { should allow_value('usd').for(:currency) }
  it { should_not allow_value('zzz').for(:currency) }

  describe '#build_pusher_channel_token' do
    subject { build(:charge, pusher_channel_token: nil) }

    it 'should generate a random hex string after being created' do
      subject.save
      subject.pusher_channel_token.length.should == 24
    end
  end

  describe '#presentation_amount' do
    let(:usd_charge) { build(:charge, currency: 'usd', amount: '1000') }
    let(:sek_charge) { build(:charge, currency: 'sek', amount: '1000') }
    let(:jpy_charge) { build(:charge, currency: 'jpy', amount: '1000') }

    it 'should display usd and sek as 10.00' do
      usd_charge.presentation_amount.should == "10.00"
      sek_charge.presentation_amount.should == "10.00"
    end

    it 'should display jpy as its original value' do
      jpy_charge.presentation_amount.should == "1000"
    end
  end

  describe '#actionkit_hash' do
    subject { build(:charge, config: {'action_foo' => 'bar', 'a' => 'b', 'akid' => 'XXX'})}

    it 'should only return the key value pairs where the key starts with action_' do
      subject.actionkit_hash.should == {'action_foo' => 'bar', 'orig_akid' => 'XXX'}
    end
  end

  describe 'application_fee' do
    subject { build_stubbed(:charge, amount: 100) }
    it 'should have a 1 percent application_fee' do
      subject.application_fee.should == 1
    end
  end
end
