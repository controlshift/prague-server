require 'spec_helper'

describe Charge do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :currency }

  describe '#build_pusher_channel_token' do
    subject { build(:charge, pusher_channel_token: nil) }

    it 'should generate a random hex string after being created' do
      subject.save
      subject.pusher_channel_token.length.should == 24
    end
  end
end
