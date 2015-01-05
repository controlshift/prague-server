# == Schema Information
#
# Table name: charges
#
#  id                   :integer          not null, primary key
#  amount               :string(255)
#  currency             :string(255)
#  customer_id          :integer
#  organization_id      :integer
#  charged_back_at      :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  pusher_channel_token :string(255)
#  config               :hstore
#  status               :string(255)      default("live")
#  paid                 :boolean          default(FALSE), not null
#  stripe_id            :string(255)
#  card                 :hstore
#  external_id          :string(255)
#  external_new_member  :boolean
#

class Charge < ActiveRecord::Base
  include LiveMode

  belongs_to :customer
  belongs_to :organization
  has_many :log_entries
  has_and_belongs_to_many :tags

  before_validation :downcase_currency
  before_validation :ensure_amount_is_number

  validates :amount, :currency, :customer, :organization, :pusher_channel_token, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: Organization::CURRENCIES.collect{|c| c.downcase} }

  before_save :update_aggregates

  scope :paid, -> { where(paid: true) }

  def presentation_amount
    self.class.presentation_amount(amount, currency)
  end

  def self.presentation_amount for_amount, for_currency
    # zero_decimal means that the currency is not represented as XXX.XX, rather its integer amount
    zero_decimal = ['BIF', 'CLP', 'JPY', 'KRW', 'PYG', 'VUV', 'XOF', 'CLP', 'GNF', 'KMF', 'MGA', 'RWF', 'XAF', 'XPF'].include?(for_currency.upcase)
    # E.g.: If zero_decimal, 12345 => "12345". Else, 12345 => "123.45"
    zero_decimal ? '%i' % for_amount.to_i.round : '%.2f' % (for_amount.to_i / 100.0)
  end

  def application_fee
    (amount.to_i * 0.01).to_i
  end

  # Converts a string of the form "{\"key\"=>\"val\"}" into a hash.
  def rate_conversion_hash
    Hash[config['rates'].split(",").collect{|c| c.tr('"}{ ', '').split("=>")}] rescue {}
  end

  def converted_amount to_currency="USD"
    conversion_hash = rate_conversion_hash
    return self.amount.to_i if conversion_hash.empty? || conversion_hash[self.currency.upcase].nil? || self.currency.upcase == to_currency.upcase
    ((amount.to_f / conversion_hash[self.currency.upcase].to_f) * conversion_hash[to_currency.upcase].to_f).to_i
  end

  def stripe_url
    if stripe_id
      "https://dashboard.stripe.com#{'/test' if status == 'test'}/payments/#{stripe_id}"
    else
      nil
    end
  end

  private

  def update_aggregates
    if self.persisted? && self.valid? && self.paid_changed?
      paid_transition = self.changes[:paid]

      # this detects a state change, since a proper state machine library felt like overkill.
      if paid_transition.first == false && paid_transition.last == true
        amt = self.converted_amount(self.organization.currency)
        # if a charge transitions to being paid, update the associated aggregate
        DateAggregation.new(organization.total_raised_key).increment(amt)
        DateAggregation.new(organization.total_charges_count_key).increment
        self.tags.each do |tag|
          tag.incrby(amt, self.status)
        end
      end
    end
  end

  def ensure_amount_is_number
    self.amount = self.amount.try(:to_i)
  end

  def downcase_currency
    self.currency = currency.downcase if currency.present?
  end
end
