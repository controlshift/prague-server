# Charge customer associated with the charge passed to the service

class ChargeCustomerAction
  attr_accessor :charge

  def initialize(charge)
    @charge = charge
  end

  def call
    tags_metadata = {}
    charge.tags.each_with_index do |tag, index|
      tags_metadata["takecharge-tag-#{index}"] = tag.name
    end

    Stripe::Charge.create({
      amount: charge.amount,
      currency: charge.currency,
      application_fee: charge.application_fee,
      source: stripe_token.id,
      metadata: {
        'charge_id' => charge.id,
        'name' => charge.customer.full_name,
        'email' => charge.customer.email
      }.merge(tags_metadata),
      description: "#{Time.zone.now.to_s} - #{charge.customer.id} - #{charge.organization.slug}"
    }, {api_key: access_token, stripe_account: charge.organization.stripe_user_id})
  end

  private

  def stripe_token
    CreateCustomerTokenAction.new(charge.customer.customer_token, charge.organization.stripe_user_id, access_token).call
  end

  def access_token
    charge.organization.live? ? ENV['STRIPE_SECRET'] : ENV['STRIPE_TEST_SECRET']
  end
end
