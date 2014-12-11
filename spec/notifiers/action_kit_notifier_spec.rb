require 'spec_helper'

describe ActionKitNotifier do
  let(:customer) { create(:customer) }
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, platform: 'actionkit', organization: organization) }
  let(:charge) { create(:charge, customer: customer, organization: organization) }

  before do
    ActionKitRest::Action.any_instance.stub(:create)
  end

  it 'should push the contribution into AK' do
    ActionKitRest::Action.any_instance.should_receive(:create)
    ActionKitNotifier.new.process(charge)
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
                                      country: 'US',
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
      ActionKitNotifier.new.process(charge)
    end
  end
end