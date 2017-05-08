class ChargeNotificationMailerWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.includes(:customer, :organization).find(charge_id)
    ChargeNotificationMailer.send_receipt(charge).deliver_now
  end
end
