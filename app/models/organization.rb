# == Schema Information
#
# Table name: organizations
#
#  id                          :integer          not null, primary key
#  access_token                :string(255)
#  stripe_publishable_key      :string(255)
#  stripe_user_id              :string(255)
#  name                        :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  email                       :string(255)
#  slug                        :string(255)
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  global_defaults             :hstore
#  encrypted_password          :string(255)      default(""), not null
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  testmode                    :boolean
#  refresh_token               :string(255)
#  stripe_live_mode            :boolean
#  stripe_publishable_test_key :string(255)
#  stripe_test_access_token    :string(255)
#

class Organization < ActiveRecord::Base
  store_accessor :global_defaults, :currency, :seedamount, :seedvalues, :redirectto, :thank_you_text, :country

  CURRENCIES = ["USD", "EUR", "AUD", "CAN", "GBP", "NZD", "NOK", "DKK", "SEK"]

  include HasSlug

  has_many :charges
  has_one  :crm
  has_many :tags
  has_many :namespaces, class_name: 'TagNamespace'
  has_many :users
  has_many :invitations
  has_many :webhook_endpoints

  validates :slug, :name, presence: true
  validates :name, uniqueness: true
  validates :seedamount, format: { with: /\A\d+\z/ }, allow_blank: true
  validates :seedvalues, format: { with: /\A(\d+\,)*\d+\z/ }, allow_blank: true
  validates :redirectto, format: { with: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/ }, allow_blank: true
  validates :currency, inclusion: { in: Organization::CURRENCIES }, presence: true

  accepts_nested_attributes_for :crm

  before_create :create_slug!
  before_save :on_currency_change
  after_save :clear_dirty_after_save

  after_initialize do
    self.currency = 'USD' if currency.blank?
  end

  after_save :flush_cache_key!

  def apply_omniauth(omniauth_hash)
    return if omniauth_hash.nil?
    logger.info "omniauth_hash #{omniauth_hash.inspect}"
    self.stripe_user_id = omniauth_hash['uid']
    self.stripe_publishable_key = omniauth_hash['info'].try(:[], 'stripe_publishable_key')
    self.access_token = omniauth_hash['credentials'].try(:[], 'token')
    self.refresh_token = omniauth_hash['credentials'].try(:[], 'refresh_token')
    self.stripe_live_mode = omniauth_hash['info'].try(:[], 'livemode')

    # retrieve test key
    client = OAuth2::Client.new self.stripe_user_id, ENV['STRIPE_SECRET'], site: 'https://connect.stripe.com/'
    rsp = client.get_token refresh_token: self.refresh_token, grant_type: 'refresh_token', client_secret: ENV['STRIPE_TEST_SECRET']
    logger.info "refresh_hash: #{rsp.params.inspect}"

    self.stripe_publishable_test_key = rsp.params['stripe_publishable_key']
    self.stripe_test_access_token = rsp.token
  end

  def status
    testmode? ? 'test' : 'live'
  end

  def live?
    !testmode
  end

  def self.find_for_stripe_oauth(auth)
    return if auth.nil? || auth['info'].blank? || auth['credentials'].blank?
    Organization.where(stripe_user_id: auth['uid']).first
  end

  def code_snippet(options={})
    tags = options.fetch(:tags, []).map { |tag_name| Tag.find_or_create!(self, tag_name) }

    CodeSnippet.new(organization: self, seedamount: seedamount, seedvalues: seedvalues, tags: tags,
                    currency: currency.upcase, testmode: self.testmode?)
  end

  def self.global_defaults_for_slug(slug)
    Rails.cache.fetch "global_defaults_#{slug}", expires_in: 24.hours do
      defaults = Organization.find_by_slug(slug).try(:global_defaults) || {}
      resp = Net::HTTP.get_response(URI.parse('http://platform.controlshiftlabs.com/cached_url/currencies'))
      data = JSON.parse(resp.body) rescue ''
      defaults[:rates] = data['rates']
      defaults
    end
  end

  # hack to support _changed? for store accessor methods.
  def currency=(value)
    @currency_changed = true if value != self.currency
    write_store_attribute(:global_defaults, :currency, value)
  end

  def currency_changed?
    @currency_changed
  end

  def clear_dirty_after_save
    @currency_changed = false
  end

  def total_raised_key
    "charges/#{self.slug}/raised"
  end

  def total_charges_count_key
    "charges/#{self.slug}/count"
  end

  def raised_last_7_days
    DateAggregation.new(total_raised_key).last_7_days
  end

  def charges_count_last_7_days
    DateAggregation.new(total_charges_count_key).last_7_days
  end

  private

  def on_currency_change
    if self.persisted? && self.valid? && currency_changed?
      # recalculate all of the totals in redis.
      self.tags.find_each do |tag|
        tag.reset_redis_keys!
      end

      self.namespaces.find_each do |namespace|
        namespace.reset_redis_keys!
      end

      self.charges.paid.find_each do |charge|
        charge.tags.find_each do |tag|
          tag.incrby(charge.converted_amount(self.currency), charge.status)
        end
      end
    end
  end

  def flush_cache_key!
    Rails.cache.delete "global_defaults_#{slug}"
    OrganizationUpdatedWorker.perform_async(id)
  end
end
