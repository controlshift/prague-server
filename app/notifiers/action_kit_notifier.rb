class ActionKitNotifier
  def process(charge)
    crm = charge.organization.crm
    ak = ActionKitRest.new(host: crm.host, username: crm.username, password: crm.password )

    if charge.currency == crm.default_currency
      post_ak_charge_for(charge, ak)
    else
      stub = crm.import_stubs.select { |st| st.donation_currency.upcase == charge.currency.upcase }.first
      post_ak_charge_for(charge, ak, stub)
    end
    LogEntry.create(charge: charge, message: 'Synchronization to ActionKit Complete')
  end

  def post_ak_charge_for(charge, ak, import_stub = nil)
    params = Adapters::ActionKit::Action.new(charge: charge, import_stub: import_stub).to_hash
    action = ak.action.create(params)
    Rails.logger.debug "Synchronizing #{charge.id} to AK with #{params}"

    charge.external_id = action.id
    charge.external_new_member = action.created_user
    charge.save!
  end
end