class ChargeCustomerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(charge_id)
    charge = Charge.find(charge_id)
    if charge.organization.access_token.present?
      run_charge(charge)
    else
      Pusher[charge.pusher_channel_token].trigger('charge_completed', {
        status: 'failure',
        message: "#{ERB::Util.html_escape(charge.organization.name)} has not been connected to Stripe."
      })
    end
  end

  private

  def run_charge(charge)
    # Get a single-use Stripe token that we will use to run the charge.
    # Since we just pass in a Stripe customer identifier, it will use the customer's default card.
    # Fortunately, we just created this Stripe customer, with the card the donor entered as the default card.
    # So it will charge the card the donor entered.
    token = get_stripe_token(charge)

    # This is where we actually charge the customer.
    stripe_charge = create_stripe_charge(charge, token)

    # Sweet, it worked!  Mark everything as successfully paid.
    mark_as_paid!(charge, stripe_charge)

    # Schedule jobs to update the organization's CRM and send the customer a receipt.
    send_notifications!(charge)

  rescue Stripe::CardError => e
    charge.update_attributes(paid: false)
    LogEntry.create(charge: charge, message: "Unsuccessful charge: #{e.message}")
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: e.message
    })
    Rails.logger.debug("Stripe::CardError #{e.message}")
  rescue Stripe::StripeError => e
    LogEntry.create(charge: charge, message: "Stripe error while processing charge: #{e.message}")

    charge.update_attributes(paid: false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: "Something went wrong, please try again."
    })
    Rails.logger.warn("Stripe::Error #{e.message}")
  rescue StandardError => e
    LogEntry.create(charge: charge, message: "Unknown error: #{e.message}")
    charge.update_attributes(paid: false)
    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: "Something went wrong, please try again."
    })
    Rails.logger.debug("StandardError #{e.message}")
    Honeybadger.notify(e, context: {charge_id: charge.id})
  end

  # Get a single-use Stripe token that we will use to run the charge.
  # Since we just pass in a Stripe customer identifier, it will use the customer's default card.
  # Fortunately, we just created this Stripe customer, with the card the donor entered as the default card.
  # So it will charge the card the donor entered.
  def get_stripe_token(charge)    
    Stripe::Token.create({ customer: charge.customer.customer_token },
      charge.live? ? charge.organization.access_token : charge.organization.stripe_test_access_token
    )
  end

  # This is where we actually charge the customer.
  def create_stripe_charge(charge, token)
    Stripe::Charge.create({
      amount: charge.amount,
      currency: charge.currency,
      application_fee: charge.application_fee,
      card: token.id,
      metadata: {
        'charge_id' => charge.id,
        'name' => charge.customer.full_name,
        'email' => charge.customer.email
      },
      description: "#{Time.zone.now.to_s} - #{charge.customer.id} - #{charge.organization.slug}"
    }, charge.live? ? charge.organization.access_token : charge.organization.stripe_test_access_token)
  end

  # Sweet, it worked!  Mark everything as successfully paid.
  def mark_as_paid!(charge, stripe_charge)
    charge.update_attributes(paid: true, stripe_id: stripe_charge[:id], card: stripe_charge[:card].to_hash )
    LogEntry.create(charge: charge, message: 'Successful charge.')

    Pusher[charge.pusher_channel_token].trigger('charge_completed', {
      status: 'success'
    })
  end

  # Schedule jobs to update the organization's CRM and send the customer a receipt.
  def send_notifications!(charge)
    CrmNotificationWorker.perform_async(charge.id)
    ChargeNotificationMailer.delay.send_receipt(charge.id)
  end
end
