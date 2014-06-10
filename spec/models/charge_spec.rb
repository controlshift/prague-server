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
require 'support/live_mode_examples'


describe Charge do
  it_behaves_like 'live mode'

  it { should validate_presence_of :amount }
  it { should validate_presence_of :currency }
  it { should validate_presence_of :pusher_channel_token }

  it { should allow_value('usd').for(:currency) }
  it { should_not allow_value('zzz').for(:currency) }

  it { should_not allow_value('zzz').for(:amount) }
  it { should_not allow_value(-100).for(:amount) }
  it { should allow_value(100).for(:amount) }
  it { should allow_value('100').for(:amount) }


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

    it 'should allow for string values of charge' do
      subject.amount = "100"
      subject.application_fee.should == 1
    end
  end
end
