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
#

class Charge < ActiveRecord::Base
  include LiveMode

  belongs_to :customer
  belongs_to :organization
  before_validation :downcase_currency
  before_validation :ensure_amount_is_number

  validates :amount, :currency, :customer, :organization, :pusher_channel_token, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: Organization::CURRENCIES.collect{|c| c.downcase} }


  def presentation_amount
    larger_unit = '%.2f' % (amount.to_i / 100.0)
    ['BIF', 'CLP', 'JPY', 'KRW', 'PYG', 'VUV', 'XOF', 'CLP', 'GNF', 'KMF', 'MGA', 'RWF', 'XAF', 'XPF'].include?(currency.upcase) ? amount : larger_unit
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

  private

  def ensure_amount_is_number
    self.amount = self.amount.try(:to_i)
  end

  def downcase_currency
    self.currency = currency.downcase if currency.present?
  end
end
