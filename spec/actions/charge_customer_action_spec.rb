require 'spec_helper'

describe ChargeCustomerAction do
  let(:account) { Stripe::Account.create }
  let(:organization) { build_stubbed(:organization, stripe_user_id: account.id) }
  let(:customer) { build_stubbed(:customer, customer_token: stripe_customer.id) }
  let(:charge) { build_stubbed(:charge, customer: customer, organization: organization, card: nil)}

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_card_token) }
  let(:stripe_card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 1984) }

  subject { ChargeCustomerAction.new(charge) }

  before(:each) do
    StripeMock.start
  end

  after(:each) do
    StripeMock.stop
  end

  describe '#initialize' do
    specify { expect(subject.charge).to eq(charge) }
  end

  describe 'call' do
    it 'should return a stripe charge object' do
      expect(subject.call).to be_a(Stripe::Charge)
    end
  end
end
