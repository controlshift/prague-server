class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable

  store_accessor :global_defaults, :currency

  CURRENCIES = ["USD", "EUR", "AUD", "CAN", "GBP"]

  include HasSlug

  has_many :charges
  has_one :crm

  validates :stripe_user_id, :stripe_publishable_key, :access_token, :slug, presence: true

  accepts_nested_attributes_for :crm

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

  def code_snippet
    "<script src=\"https://s3.amazonaws.com/prague-production/jquery.donations.loader.js\" id=\"donation-script\" data-org=\"#{slug}\" 
      data-pathtoserver=\"https://www.donatelab.com\" data-stripepublickey=\"pk_live_TkBE6KKwIBdNjc3jocHvhyNx\"></script>"
  end
end
