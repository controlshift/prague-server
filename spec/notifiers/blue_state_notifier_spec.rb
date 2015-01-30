require 'spec_helper'

describe BlueStateNotifier do
  let(:customer) { create(:customer) }
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, platform: 'bluestate', organization: organization) }
  let(:charge) { create(:charge, customer: customer, organization: organization) }

  before :each do
    mock_connection = double()
    allow(mock_connection).to receive(:perform_request).and_return('{"summary": {"missing_ids": 0, "failures": 0}}')
    allow(BlueStateDigital::Connection).to receive(:new).and_return(mock_connection)
  end

  it 'should push the contribution into BSD' do
    expect_any_instance_of(BlueStateDigital::Contribution).to receive(:save)
    BlueStateNotifier.new.process(charge)
  end

  it 'should convert amounts into the default currency for the CRM' do
    crm.default_currency = 'XYZ'
    charge.amount = 123
    expect(charge).to receive(:converted_amount).with('XYZ').and_return(23456)
    expect(BlueStateDigital::Contribution).to receive(:new) do |options|
      expect(options[:transaction_amt]).to eq(234.56)
      double().as_null_object
    end
    BlueStateNotifier.new.process(charge)
  end

  it "should push all tags as sources into BSD" do
    tag_names = ['takecharge']
    (0...5).each do
      charge.tags << (tag = create(:tag, organization: organization))
      tag_names << "takecharge:#{tag.name}"
    end
    charge.save!

    expect(BlueStateDigital::Contribution).to receive(:new) do |options|
      expect(options[:source]).to match_array(tag_names)
      double.as_null_object
    end

    BlueStateNotifier.new.process(charge)
  end
end
