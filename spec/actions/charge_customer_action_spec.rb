require 'spec_helper'

describe ChargeCustomerAction do
  let(:organization) { build_stubbed(:organization) }
  let(:customer) { build_stubbed(:customer, customer_token: 'xxx') }
  let(:charge) { build_stubbed(:charge, customer: customer, organization: organization, card: nil)}

  describe '#initialize' do
    describe 'without an access token' do
      let(:organization) { build_stubbed(:organization, access_token: nil) }

      it 'raises an exception when initialized with organization without access token' do
        expect { ChargeCustomerAction.new(charge) }.to raise_error(ArgumentError)
      end
    end

    subject { ChargeCustomerAction.new(charge) }

    specify { expect(subject.charge).to eq(charge) }
    specify { expect(subject.access_token).to eq(organization.access_token)}
  end
end
