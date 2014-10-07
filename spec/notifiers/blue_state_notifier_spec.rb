require 'spec_helper'

describe BlueStateNotifier do
  let(:customer) { create(:customer) }
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, platform: 'bluestate', organization: organization) }
  let(:charge) { create(:charge, customer: customer, organization: organization) }

  it 'should push the contribution into BSD' do
    BlueStateDigital::Contribution.any_instance.should_receive(:save)
    BlueStateNotifier.new.process(charge)
  end
end