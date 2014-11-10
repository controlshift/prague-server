# Schedule jobs to update the organization's CRM and send the customer a receipt.

class NotificationAction
  def initialize(charge)
    @charge = charge
  end

  def call
    CrmNotificationWorker.perform_async(@charge.id)
    ChargeNotificationMailer.delay.send_receipt(@charge.id)
  end
end
