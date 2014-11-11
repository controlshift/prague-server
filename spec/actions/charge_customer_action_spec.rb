require 'spec_helper'

describe ChargeCustomerAction do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, customer_token: 'xxx') }
  let(:charge) { build(:charge, customer: customer, organization: organization, card: nil)}

  describe '#initialize' do
    it 'raises an exception when initialized with organization without access token' do
      charge.organization.access_token = nil
      expect { ChargeCustomerAction.new(charge) }.to raise_error(ArgumentError)
    end
  end
end
