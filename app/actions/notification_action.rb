# Schedule jobs to update the organization's CRM and send the customer a receipt.

class NotificationAction
  attr_accessor :charge

  def initialize(charge)
    @charge = charge
  end

  def call
    CrmNotificationWorker.perform_async(charge.id)
    ChargeNotificationMailerWorker.perform_async(charge.id)
  end
end
