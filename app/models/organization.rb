class Organization < ActiveRecord::Base
  include HasSlug

  has_many :charges

  validates :stripe_user_id, :stripe_publishable_key, :access_token, :slug, presence: true

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

  def code_snippet
    "<script src=\"https://s3.amazonaws.com/prague-production/jquery.donations.loader.js\" id=\"donation-script\" data-org=\"#{slug}\" 
      data-pathtoserver=\"https://www.donatelab.com\" data-stripepublickey=\"pk_live_TkBE6KKwIBdNjc3jocHvhyNx\"></script>"
  end
end
