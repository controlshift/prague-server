# == Schema Information
#
# Table name: customers
#
#  id             :integer          not null, primary key
#  customer_token :string
#  first_name     :string
#  last_name      :string
#  country        :string
#  zip            :string
#  email          :string
#  created_at     :datetime
#  updated_at     :datetime
#  status         :string           default("live")
#

require 'spec_helper'
require 'support/live_mode_examples'

describe Customer do
  it_behaves_like 'live mode'

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :country }

  it { is_expected.to allow_value('george@washington.com').for(:email) }
  it { is_expected.not_to allow_value('xxx').for(:email) }

  describe '#full_name' do
    let(:customer) { build(:customer, first_name: "Foo", last_name: "Bar") }
    subject { customer.full_name }

    it { is_expected.to eq 'Foo Bar' }
  end

  describe '.find_or_initialize' do
    let(:customer) { create(:customer, email: "something@gmail.com") }
    it 'should find and update an existing customer' do
      my_id = customer.id
      customer2 = Customer.find_or_initialize({ first_name: "Foo", last_name: "Bar",
        country: "US", email: "sometHIng@gmail.com" }, status: 'live' )
      expect(customer2.id).to eq customer.id
    end
  end

  describe "unique email validation" do
    let(:customer1) { Customer.new attributes_for(:customer, email: first_customer_email)}
    let(:customer2) { Customer.new attributes_for(:customer, email: second_customer_email)}

    let(:first_customer_email) { "ANemail@email.com" }
    let(:second_customer_email) { "ANEMAIL@EMAIL.COM" }

    it "should reject duplicate emails in different case for the same parent" do
      expect(customer1.save).to be_truthy
      expect(customer2.save).to be_falsey
      customer2.status = 'test'
      expect(customer2.save).to be_truthy
    end
  end
end
