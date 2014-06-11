class CreateCustomerTokenWorker
  include Sidekiq::Worker

  def perform(customer_id, card_token, charge_id)
    customer = Customer.find(customer_id)
    charge = Charge.find(charge_id)
    if customer.customer_token.present?
      charge_customer(customer)
    else
      stripe_customer = Stripe::Customer.create(
        {
          email: customer.email,
          metadata: customer.to_hash,
          card: card_token,
          description: customer.id
        },
        organization.live? ? ENV['STRIPE_SECRET'] : ENV['STRIPE_TEST_SECRET']
      )
      customer.update_attribute(:customer_token, stripe_customer.id)
      ChargeCustomerWorker.perform_async(charge.id)
    end
  end
end
