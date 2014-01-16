class CreateCustomerTokenWorker
  include Sidekiq::Worker

  def perform(customer_id, card_token)
    customer = Customer.find(customer_id)
    stripe_customer = Stripe::Customer.create(
      card: card_token,
      description: customer.id)
    customer.update_attribute(:customer_token, stripe_customer.id)
  end
end