require 'spec_helper'

describe CrmNotificationWorker do
  
  let(:charge) { create(:charge,
    customer: create(:customer), 
    organization: create(:organization,
      crm: create(:crm)))}

  describe '#perform' do
    before do
      charge
      ActionKitRest::Action.any_instance.stub(:create)
      Sidekiq::Testing.inline!
    end

    specify 'should notify ActionKit' do
      ActionKitRest::Action.any_instance.should_receive(:create)
      CrmNotificationWorker.perform_async(charge.id)
    end
  end
end
