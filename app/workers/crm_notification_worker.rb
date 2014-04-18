class CrmNotificationWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.includes(:customer, organization: [:crm]).find(charge_id)
    return if charge.organization.crm.nil?
    case charge.organization.crm.platform
    when 'actionkit'
      process_with_actionkit(charge)
    end
  end

  def process_with_actionkit charge
    crm = charge.organization.crm
    ak = ActionKitRest.new(host: crm.host, username: crm.username, password: crm.password )
    ak.action.create(charge.actionkit_hash.merge({
      page: charge.config.try(:[], 'page') || crm.donation_page_name,
      email: charge.customer.email,
      name: "#{charge.customer.first_name} #{charge.customer.last_name}",
      address1: 'Processed by TakeCharge',
      state: 'NY',
      city: 'New York',
      zip: '10001',
      card_num: '4111111111111111',
      card_code: '007',
      exp_date_month: "#{1.month.from_now.strftime('%m')}",
      exp_date_year: "#{1.month.from_now.strftime('%y')}",
      amount_other: charge.presentation_amount
    }))
  end
end
