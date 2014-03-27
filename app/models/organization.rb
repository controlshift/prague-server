class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:stripe_connect]
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

  def self.find_for_stripe_oauth auth
    return if auth.nil? || auth['info'].blank? || auth['credentials'].blank?
    Organization.where(stripe_user_id: auth['uid'])
      .where(stripe_publishable_key: auth['info']['stripe_publishable_key'])
      .where(access_token: auth['credentials']['token'])
      .first
  end
end
