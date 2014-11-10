# Charge customer associated with the charge passed to the service

class ChargeCustomerService
  def initialize(charge)
    @charge = charge
    @access_token = charge.live? ? charge.organization.access_token : charge.organization.stripe_test_access_token
    raise ArgumentError.new('Organization must have Stripe access token') unless @access_token
  end

  def call
    Stripe::Charge.create({
      amount: @charge.amount,
      currency: @charge.currency,
      application_fee: @charge.application_fee,
      card: stripe_token.id,
      metadata: {
        'charge_id' => @charge.id,
        'name' => @charge.customer.full_name,
        'email' => @charge.customer.email
      },
      description: "#{Time.zone.now.to_s} - #{@charge.customer.id} - #{@charge.organization.slug}"
    }, @access_token)
  end

  private

  def stripe_token
    CreateCustomerTokenService.new(@charge.customer.customer_token, @access_token).call
  end
end
