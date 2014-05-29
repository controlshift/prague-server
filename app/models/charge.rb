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
  belongs_to :customer
  belongs_to :organization
  before_validation :downcase_currency

  validates :amount, :currency, :customer, :organization, presence: true

  validates :currency, inclusion: { in: Organization::CURRENCIES.collect{|c| c.downcase} }

  before_create :build_pusher_channel_token, :ensure_amount_is_number

  def ensure_amount_is_number
    self.amount = self.amount.to_i
  end

  def build_pusher_channel_token
    self.pusher_channel_token = Array.new(24){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end

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
  def downcase_currency
    self.currency = currency.downcase if currency.present?
  end
end
