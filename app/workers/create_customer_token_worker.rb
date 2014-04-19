class CreateCustomerTokenWorker
  include Sidekiq::Worker

  def perform(customer_id, card_token)
    customer = Customer.find(customer_id)
    if customer.customer_token.present?
      ChargeCustomerWorker.perform_async(customer.charges.first.id)
    else
      stripe_customer = Stripe::Customer.create(
        email: customer.email,
        metadata: customer.to_hash,
        card: card_token,
        description: customer.id)
      customer.update_attribute(:customer_token, stripe_customer.id)
      ChargeCustomerWorker.perform_async(customer.charges.first.id)
    end
  end
end
