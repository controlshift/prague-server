class Org::Settings::StripeController < Org::OrgController
  def show
    @account = Stripe::Account.retrieve(stripe_access_token) if stripe_access_token.present?
  end
end