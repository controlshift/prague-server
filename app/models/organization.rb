class Organization < ActiveRecord::Base
  validates_presence_of :stripe_user_id, :stripe_publishable_key, :access_token

  def apply_omniauth omniauth_hash
    return if omniauth_hash.nil?
    self.stripe_user_id = omniauth_hash['uid']
    self.stripe_publishable_key = omniauth_hash['info'].try(:[], 'stripe_publishable_key')
    self.access_token = omniauth_hash['credentials'].try(:[], 'token')
  end
end
