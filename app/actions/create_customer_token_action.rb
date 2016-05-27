# Get a single-use Stripe token that we will use to run the charge.
# Since we just pass in a Stripe customer identifier, it will use the customer's default card.

class CreateCustomerTokenAction
  attr_accessor :customer_token, :account_id, :access_token
  def initialize(customer_token, account_id, access_token)
    @customer_token = customer_token
    @account_id = account_id
    @access_token = access_token
  end

  def call
    Stripe::Token.create({ customer: customer_token}, {api_key: access_token, stripe_account: account_id})
  end
end
