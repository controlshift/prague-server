class CreateCustomerTokenWorker
  include Sidekiq::Worker

  def perform(customer_id, card_token)
    customer = Customer.find(customer_id)
    if customer.customer_token.present?
      ChargeCustomerWorker.perform_async(customer.charges.first.id)
    else
      unless customer.charges.first.organization.testmode?
        stripe_customer = Stripe::Customer.create(
          {
            email: customer.email,
            metadata: customer.to_hash,
            card: card_token,
            description: customer.id
          },
          ENV['STRIPE_SECRET']
        )
        customer.update_attribute(:customer_token, stripe_customer.id)
      end
      ChargeCustomerWorker.perform_async(customer.charges.first.id)
    end
  end
end
