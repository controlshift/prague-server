# == Schema Information
#
# Table name: customers
#
#  id             :integer          not null, primary key
#  customer_token :string(255)
#  first_name     :string(255)
#  last_name      :string(255)
#  country        :string(255)
#  zip            :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'
require 'support/live_mode_examples'

describe Customer do
  it_behaves_like 'live mode'

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :country }

  it { should allow_value('george@washington.com').for(:email) }
  it { should_not allow_value('xxx').for(:email) }

  describe '#full_name' do
    subject { build(:customer, first_name: "Foo", last_name: "Bar") }
    its(:full_name) { should == "Foo Bar" }
  end
end
