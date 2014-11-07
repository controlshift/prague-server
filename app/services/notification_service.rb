# Schedule jobs to update the organization's CRM and send the customer a receipt.

class NotificationService
  def initialize(charge)
    @charge = charge
  end

  def call
    CrmNotificationWorker.perform_async(@charge.id)
    ChargeNotificationMailer.delay.send_receipt(@charge.id)
  end
end
