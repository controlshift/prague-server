class ChargeNotificationMailer < ActionMailer::Base

  def send_receipt charge_id
    @charge = Charge.includes(:customer, :organization).find(charge_id)
    mail to: @charge.customer.email,
      subject: "Thanks for donating to #{@charge.organization.name}"
  end
end