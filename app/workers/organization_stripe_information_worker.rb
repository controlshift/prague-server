class OrganizationStripeInformationWorker
  include Sidekiq::Worker

  def perform(organization_id)
    organization = Organization.find(organization_id)
    account = Stripe::Account.retrieve(organization.access_token)
    organization.update_attributes(name: account.display_name, email: account.email)
  end
end
