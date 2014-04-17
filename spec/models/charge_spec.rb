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
#

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
