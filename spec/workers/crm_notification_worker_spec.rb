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
        expect( CrmNotificationWorker.new.perform(charge.id) ).to eq(true)
      end
    end

    describe 'actionkit' do
      let!(:crm) { create(:crm, platform: 'actionkit', organization: organization) }

      before do
        ActionKitRest::Action.any_instance.stub(:create)
      end

      specify 'should notify ActionKit' do
        ActionKitRest::Action.any_instance.should_receive(:create)
        CrmNotificationWorker.new.perform(charge.id)
      end

      context 'with an import stub' do
        let!(:import_stub) { create(:import_stub, donation_currency: "JPY", crm: crm )}

        specify 'should be able to match an import stub to a currency' do
          charge.update_attribute(:currency, 'JPY')
          charge.organization.crm.import_stubs.last.update_attribute(:donation_currency, 'JPY')
          ActionKitRest::Action.any_instance.should_receive(:create).with(
            charge.actionkit_hash.merge({
              page: crm.donation_page_name,
              email: charge.customer.email,
              name: charge.customer.full_name,
              card_num: '4111111111111111',
              card_code: '007',
              exp_date_month: "#{1.month.from_now.strftime('%m')}",
              exp_date_year: "#{1.month.from_now.strftime('%y')}",
              amount_other: "#{charge.amount}",
              action_charge_id: charge.id,
              action_charge_status: charge.status,
              action_charge_currency: charge.currency.upcase,
              payment_account: import_stub.payment_account,
              currency: import_stub.donation_currency
            })
          )
          CrmNotificationWorker.new.perform(charge.id)
        end
      end
    end

    describe 'bluestate' do
      let!(:crm) { create(:crm, platform: 'bluestate', organization: organization) }

      it 'should notify bsd' do
        BlueStateDigital::Contribution.any_instance.should_receive(:save)
        CrmNotificationWorker.new.perform(charge.id)
      end
    end
  end
end
