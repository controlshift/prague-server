class OrganizationStripeInformationWorker
  include Sidekiq::Worker

  def perform(organization_id, update_slug = false)
    organization = Organization.find(organization_id)
    account = Stripe::Account.retrieve(organization.stripe_user_id)
    organization.update_attributes(name: account.display_name, email: account.email)
    organization.update_slug! && organization.save! if update_slug
  end
end
