class Organization < ActiveRecord::Base
  include HasSlug
  
  validates_presence_of :stripe_user_id, :stripe_publishable_key, :access_token

  after_create :update_account_information_from_stripe!

  def update_account_information_from_stripe!
    OrganizationStripeInformationWorker.perform_async(self.id)
  end

  def apply_omniauth omniauth_hash
    return if omniauth_hash.nil?
    self.stripe_user_id = omniauth_hash['uid']
    self.stripe_publishable_key = omniauth_hash['info'].try(:[], 'stripe_publishable_key')
    self.access_token = omniauth_hash['credentials'].try(:[], 'token')
  end
end
