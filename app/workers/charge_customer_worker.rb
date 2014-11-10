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
      stripe_charge = ChargeCustomerService.new(charge).call
      MarkChargeAsPaidService.new(charge, stripe_charge).call
      NotificationService.new(charge).call

    rescue Stripe::CardError => e
      ErrorService.new(charge, e, "Unsuccessful charge: #{e.message}", e.message).call
    rescue Stripe::StripeError => e
      ErrorService.new(charge, e, "Stripe error while processing charge: #{e.message}").call
    rescue StandardError => e
      ErrorService.new(charge, e, "Unknown error: #{e.message}").call
      Honeybadger.notify(e, context: {charge_id: charge.id})
    end
  end
end
