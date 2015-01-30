require 'spec_helper'

describe ActionKitNotifier do
  let(:customer) { create(:customer) }
  let(:organization) { create(:organization) }
  let!(:crm) { create(:crm, platform: 'actionkit', organization: organization) }
  let(:charge) { create(:charge, customer: customer, organization: organization) }

  let(:response_obj) { double }

  before(:each) do
    allow(response_obj).to receive(:user).and_return('/rest/v1/user/39520/')
    allow(response_obj).to receive(:id).and_return("123")
    allow(response_obj).to receive(:created_user).and_return(true)
  end

  it 'should push the contribution into AK' do
    expect_any_instance_of(ActionKitRest::Action).to receive(:create).and_return(response_obj)
    ActionKitNotifier.new.process(charge)
  end

  context 'with an import stub' do
    let!(:import_stub) { create(:import_stub, donation_currency: "GBP", crm: crm )}
    let(:charge) { create(:charge, customer: customer, organization: organization, currency: 'gbp') }

    specify 'should be able to match an import stub to a currency' do
      charge.organization.crm.import_stubs.last.update_attribute(:donation_currency, 'GBP')
      expect_any_instance_of(ActionKitRest::Action).to receive(:create).with(
       ({
          page: crm.donation_page_name,
          email: charge.customer.email,
          name: charge.customer.full_name,
          card_num: '4111111111111111',
          card_code: '007',
          country: 'US',
          zip: charge.customer.zip,
          exp_date_month: 1.month.from_now.strftime('%m'),
          exp_date_year: 1.month.from_now.strftime('%y'),
          amount_other: charge.presentation_amount,
          action_charge_id: charge.id,
          action_charge_status: charge.status,
          action_charge_currency: charge.currency.upcase,
          payment_account: import_stub.payment_account,
          currency: import_stub.donation_currency
       })
      ).and_return(response_obj)


      ActionKitNotifier.new.process(charge)
    end
  end
end