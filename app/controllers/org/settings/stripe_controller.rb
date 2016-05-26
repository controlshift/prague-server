class Org::Settings::StripeController < Org::OrgController
  def show
    @account = Stripe::Account.retrieve(current_organization.stripe_user_id) if current_organization.stripe_user_id.present?
  end
end
