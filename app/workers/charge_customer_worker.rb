class ChargeCustomerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(charge_id)
    charge = Charge.find(charge_id)
    if charge.organization.access_token.present?
      run_charge(charge)
    else
      Pusher[charge.pusher_channel_token].trigger('charge_completed', {
        status: 'failure',
        message: "#{ERB::Util.html_escape(charge.organization.name)} has not been connected to Stripe."
      })
    end
  end

  private

  def run_charge(charge)
    begin
      stripe_charge = ChargeCustomerAction.new(charge).call
      MarkChargeAsPaidAction.new(charge, stripe_charge).call
      NotificationAction.new(charge).call

    rescue Stripe::CardError => e
      ErrorAction.new(charge, e, "Unsuccessful charge: #{e.message}", e.message).call
    rescue Stripe::StripeError => e
      ErrorAction.new(charge, e, "Stripe error while processing charge: #{e.message}").call
    rescue StandardError => e
      ErrorAction.new(charge, e, "Unknown error: #{e.message}").call
      Raven.capture_exception(e)
    end
  end
end
