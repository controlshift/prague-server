require 'spec_helper'

describe CrmNotificationWorker do

  let(:customer) { create(:customer) }
  let(:organization) { create(:organization) }
  let(:crm) { create(:crm, organization: organization) }
  let(:charge) { create(:charge, customer: customer, organization: organization) }

  describe '#perform' do
    describe 'without a crm' do
      let(:crm) { nil }
      it 'should log and return' do
        expect( subject.perform(charge.id) ).to eq(true)
      end
    end

    describe 'actionkit' do
      let!(:crm) { create(:crm, platform: 'actionkit', organization: organization) }

      specify 'should notify ActionKit' do
        ActionKitNotifier.any_instance.should_receive(:process).with(charge)
        CrmNotificationWorker.new.perform(charge.id)
      end
    end

    describe 'bluestate' do
      let!(:crm) { create(:crm, platform: 'bluestate', organization: organization) }

      it 'should notify bsd' do
        BlueStateNotifier.any_instance.should_receive(:process).with(charge)
        subject.perform(charge.id)
      end
    end
  end
end
