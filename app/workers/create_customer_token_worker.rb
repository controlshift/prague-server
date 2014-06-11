class CreateCustomerTokenWorker
  include Sidekiq::Worker

  def perform(customer_id, card_token)
    customer = Customer.find(customer_id)
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
        ENV['STRIPE_SECRET']
      )
      customer.update_attribute(:customer_token, stripe_customer.id)
      charge_customer(customer)
    end
  end

  def charge_customer customer
    customer.charges.where.not(paid: true).each do |charge|
      ChargeCustomerWorker.perform_async(charge.id)
    end
  end
end
