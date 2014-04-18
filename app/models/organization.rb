# == Schema Information
#
# Table name: organizations
#
#  id                     :integer          not null, primary key
#  access_token           :string(255)
#  stripe_publishable_key :string(255)
#  stripe_user_id         :string(255)
#  name                   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)
#  slug                   :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  global_defaults        :hstore
#

class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable

  store_accessor :global_defaults, :currency

  CURRENCIES = ["USD", "EUR", "AUD", "CAN", "GBP", "NZD", "NOK", "DKK", "SEK"]

  include HasSlug

  has_many :charges
  has_one :crm

  validates :stripe_user_id, :stripe_publishable_key, :access_token, :slug, presence: true

  accepts_nested_attributes_for :crm

  after_save :flush_cache_key!

  def apply_omniauth omniauth_hash
    return if omniauth_hash.nil?
    self.stripe_user_id = omniauth_hash['uid']
    self.stripe_publishable_key = omniauth_hash['info'].try(:[], 'stripe_publishable_key')
    self.access_token = omniauth_hash['credentials'].try(:[], 'token')
  end

  def self.find_for_stripe_oauth auth
    return if auth.nil? || auth['info'].blank? || auth['credentials'].blank?
    Organization.where(stripe_user_id: auth['uid']).first
  end

  def code_snippet
    "<script src=\"https://s3.amazonaws.com/prague-production/jquery.donations.loader.js\" id=\"donation-script\" data-org=\"#{slug}\" 
      data-pathtoserver=\"https://www.donatelab.com\" data-stripepublickey=\"pk_live_TkBE6KKwIBdNjc3jocHvhyNx\" data-seedamount=\"10\"
      data-seedvalues=\"50,100,200,300,400,500,600\", data-seedcurrency=\"#{global_defaults.present? ? global_defaults['currency'] : "USD"}\"></script>"
  end

  def self.global_defaults_for_slug slug
    Rails.cache.fetch "global_defaults_#{slug}", expires_in: 24.hours do
      defaults = Organization.find_by_slug(slug).global_defaults
      resp = Net::HTTP.get_response(URI.parse('http://platform.controlshiftlabs.com/cached_url/currencies'))
      data = JSON.parse(resp.body)
      defaults[:rates] = data['rates']
      defaults.to_json
    end
  end

  private

  def flush_cache_key!
    Rails.cache.delete "global_defaults_#{slug}"
  end
end
