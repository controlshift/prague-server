class ChargeCustomerWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.find(charge_id)
    Stripe::Charge.create({
        amount: charge.amount,
        currency: charge.currency,
        customer: charge.customer.customer_token,
        description: "#{Time.zone.now.to_s} - #{charge.customer.id} - #{charge.organization.slug}"
      },
      charge.organization.access_token
    )
  end
end