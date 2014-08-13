class CreateCustomerTokenWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(customer_id, card_token, charge_id)
    customer = Customer.find(customer_id)
    charge = Charge.find(charge_id)
    stripe_customer = Stripe::Customer.create(
      {
        email: customer.email,
        metadata: customer.to_hash,
        card: card_token,
        description: customer.id
      },
      charge.organization.live? ? ENV['STRIPE_SECRET'] : ENV['STRIPE_TEST_SECRET']
    )
    customer.update_attribute(:customer_token, stripe_customer.id)
    LogEntry.create(charge: charge, message: "Customer #{stripe_customer.id} created.")
    ChargeCustomerWorker.perform_async(charge.id)
  rescue Stripe::StripeError => e
    LogEntry.create(charge: charge, message: 'An error occurred while creating customer: ' + e.message)
    charge.update_attribute(:paid, false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
    Rails.logger.debug("Stripe::StripeError #{e.message}")
  rescue StandardError => e
    LogEntry.create(charge: charge, message: 'An unknown error occurred while creating customer: ' + e.message)
    charge.update_attribute(:paid, false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
    Rails.logger.warn("Exception #{e.message}")
    Honeybadger.notify(e, context: {charge_id: charge.id})
  end
end
