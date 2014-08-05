class CrmNotificationWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.includes(:customer, organization: [:crm]).find(charge_id)
    return if charge.organization.crm.nil?
    case charge.organization.crm.platform
      when 'actionkit'
        ActionKitNotifier.new.process(charge)
        LogEntry.create(charge: charge, message: 'Synchronized to ActionKit')
      when 'bluestate'
        BlueStateNotifier.new.process(charge)
        LogEntry.create(charge: charge, message: 'Synchronized to Blue State Digital')
      else
        Rails.log.warn("No notifier for #{charge.organization.crm.platform}")
    end
  end
end
