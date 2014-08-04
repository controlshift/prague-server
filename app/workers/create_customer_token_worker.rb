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
    ChargeCustomerWorker.perform_async(charge.id)
  rescue Stripe::StripeError => e
    charge.update_attribute(:paid, false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
    Rails.logger.debug("Stripe::StripeError #{e.message}")
  rescue StandardError => e
    charge.update_attribute(:paid, false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
    Rails.logger.warn("Exception #{e.message}")
    Honeybadger.notify(
      :error_class   => "Exception",
      :error_message => "Exception: #{e.message}",
      :parameters    => [ customer_id, card_token, charge_id ]
    ) if defined? Honeybadger
  end
end
