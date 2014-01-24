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
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'success'
    })
  rescue Stripe::CardError => e
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
  rescue Stripe::StripeError
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: 'Something went wrong, please try again.'
    })
  end
end
