class CreateCustomerTokenWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(customer_id, card_token, charge_id)
    customer = Customer.find(customer_id)
    charge = Charge.find(charge_id)

    # Create a Stripe customer, with the card the user entered as the default card.
    stripe_customer = Stripe::Customer.create(
      {
        email: customer.email,
        metadata: customer.to_hash,
        source: card_token,
        validate: false,
        description: customer.id
      },
      { api_key: charge.organization.live? ? ENV['STRIPE_SECRET'] : ENV['STRIPE_TEST_SECRET']}
    )

    # Store the Stripe customer ID on the prague customer.
    customer.update_attribute(:customer_token, stripe_customer.id)

    LogEntry.create!(charge: charge, message: "Customer #{stripe_customer.id} created.")

    # Schedule a job to actually run the charge.
    ChargeCustomerWorker.perform_async(charge.id)
  rescue Stripe::StripeError => e
    ErrorAction.new(charge, e, "An error occurred while creating customer: #{e.message}", e.message).call
  rescue StandardError => e
    ErrorAction.new(charge, e, "An unknown error occurred while creating customer: #{e.message}", e.message).call
    Raven.capture_exception(e)
  end
end
