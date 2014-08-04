class CrmNotificationWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.includes(:customer, organization: [:crm]).find(charge_id)
    return if charge.organization.crm.nil?
    case charge.organization.crm.platform
    when 'actionkit'
      process_with_actionkit(charge)
      LogEntry.create(charge: charge, message: 'Synchronized to ActionKit')
    end
  end

  def process_with_actionkit charge
    crm = charge.organization.crm
    ak = ActionKitRest.new(host: crm.host, username: crm.username, password: crm.password )
    if charge.currency == crm.default_currency
      post_ak_charge_for(crm, charge, ak)
    else 
      stub = crm.import_stubs.select { |st| st.donation_currency.upcase == charge.currency.upcase }.first
      post_ak_charge_for(crm, charge, ak, stub, stub.blank?)
    end
  end

  def post_ak_charge_for crm, charge, ak, import_stub = nil, currency_not_found = false
    charge_amount = currency_not_found ? charge.converted_amount(crm.default_currency) : charge.amount
    params = charge.actionkit_hash.merge({
      page: charge.config.try(:[], 'page') || crm.donation_page_name,
      email: charge.customer.email,
      name: charge.customer.full_name,
      card_num: '4111111111111111',
      card_code: '007',
      exp_date_month: "#{1.month.from_now.strftime('%m')}",
      exp_date_year: "#{1.month.from_now.strftime('%y')}",
      amount_other: Charge.presentation_amount(charge_amount, charge.currency.upcase),
      action_charge_id: charge.id,
      action_charge_status: charge.status,
      action_charge_currency: charge.currency.upcase
    })
    if import_stub.present?
      params = params.merge({
        payment_account: import_stub.payment_account,
        currency: import_stub.donation_currency
      })
    end
    ak.action.create(params)
  end
end
