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
#  status               :string(255)      default("live")
#  paid                 :boolean          default(FALSE), not null
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

  it { should have_and_belong_to_many :tags }


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

  describe '.presentation_amount' do
    it 'should display usd as 10.00' do
      Charge.presentation_amount(1000, 'USD').should == '10.00'
    end

    it 'should accept strings as input' do
      Charge.presentation_amount('1000', 'USD').should == '10.00'
    end
  end

  describe '#update_aggregates' do
    let!(:organization) { create(:organization) }
    let(:tag_namespace) { build(:tag_namespace, namespace: 'color') }
    let(:tag) { build(:tag, name: 'color:green', organization: organization, namespace: tag_namespace) }
    let(:charge) { build(:charge, tags: [tag]) }

    before :each do
      charge.save!
    end

    after :each do
      # Clean up what we put in redis
      PragueServer::Application.redis.zrem(tag.namespace.most_raised_key, tag.name)
    end

    it 'should update the total for the tag in redis when the charge becomes paid' do
      charge.paid = true
      charge.save!
      expect(PragueServer::Application.redis.zscore(tag.namespace.most_raised_key, tag.name)).to eq(charge.converted_amount)
    end

    it 'should not update the total if the charge is not paid yet' do
      charge.paid = false
      charge.save!
      expect(PragueServer::Application.redis.zscore(tag.namespace.most_raised_key, tag.name)).to be_nil
    end

    it 'should handle multiple charges' do
      charge.paid = true
      charge.save!
      expect(PragueServer::Application.redis.zscore(tag.namespace.most_raised_key, tag.name)).to eq(charge.converted_amount)
      another_charge = create(:charge, tags: [tag])
      another_charge.paid = true
      another_charge.save!
      expect(PragueServer::Application.redis.zscore(tag.namespace.most_raised_key, tag.name)).to eq(charge.converted_amount + another_charge.converted_amount)
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

  describe '#rate_conversion_hash' do
    subject { build(:charge, config: { rates: "{\"BBD\"=>2, \"JPY\"=>101.7245}"}) }

    it "should read in the string to a ruby hash" do
      subject.rate_conversion_hash['BBD'].should == '2'
    end
  end

  describe '#converted_amount' do
    subject { build(:charge, amount: 1000, currency: 'BBD', config: { rates: "{\"BBD\"=>2, \"JPY\"=>101.7245, \"USD\"=>1}"}) }

    it 'should convert the amount to usd by default' do
      subject.converted_amount.should == 500
    end

    it 'should convert to another currency on request' do
      subject.converted_amount("JPY").should == 50862
    end

    let(:weird_currency_charge) { build(:charge, amount: 1000, currency: 'DOESNOTEXIST') }

    it 'should convert the amount to usd by default' do
      weird_currency_charge.converted_amount.should == 1000
    end

    let(:usd_charge) { build(:charge, amount: 1000, currency: "USD") }

    it 'should be able to return the original amount' do
      usd_charge.converted_amount.should == 1000
    end
  end
end
