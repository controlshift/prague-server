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

  def actionkit_hash
    if config.present?
      config.select { |k,v| k.start_with? "action_" || k == "source" }.merge({ 'orig_akid' => config['akid'] })
    else
      {}
    end
  end

  # Converts a string of the form "{\"key\"=>\"val\"}" into a hash.
  def rate_conversion_hash
    Hash[config['rates'].split(",").collect{|c| c.tr('"}{ ', '').split("=>")}] rescue {}
  end

  def converted_amount to_currency="USD"
    conversion_hash = rate_conversion_hash
    return amount if conversion_hash.empty? || conversion_hash[currency.upcase].nil? || conversion_hash[currency.upcase].nil?
    ((amount.to_f / conversion_hash[currency.upcase].to_f) * conversion_hash[to_currency.upcase].to_f).to_i
  end

  private

  def update_aggregates
    if self.persisted? && self.valid? && self.paid_changed?
      paid_transition = self.changes[:paid]

      # this detects a state change, since a proper state machine library felt like overkill.
      if paid_transition.first == false && paid_transition.last == true
        # if a charge transitions to being paid, update the associated aggregate
        self.tags.each do |tag|
          tag.incrby(self.converted_amount(self.organization.currency), self.status)
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
