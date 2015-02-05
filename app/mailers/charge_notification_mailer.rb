class ChargeNotificationMailer < ActionMailer::Base

  def send_receipt charge_id
    @charge = Charge.includes(:customer, :organization).find(charge_id)
    mail to: @charge.customer.email,
      from: @charge.organization.contact_email.present? ? @charge.organization.contact_email : (ENV['ADMIN_EMAIL'] || Rails.application.config.action_mailer.default_options[:from]),
      subject: "Thanks for donating to #{@charge.organization.name}"
  end
end