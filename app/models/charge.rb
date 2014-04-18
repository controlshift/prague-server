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
#

class Charge < ActiveRecord::Base
  belongs_to :customer
  belongs_to :organization

  validates :amount, :currency, :customer, :organization, presence: true

  validates :currency, inclusion: { in: Organization::CURRENCIES.collect{|c| c.downcase} }

  before_create :build_pusher_channel_token

  def build_pusher_channel_token
    self.pusher_channel_token = Array.new(24){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end

  def presentation_amount
    larger_unit = '%.2f' % (amount.to_i / 1000.0)
    ['USD', 'AUD', 'EUR', 'CAN', 'GBP'].include?(currency.upcase) ? larger_unit : amount
  end

  def actionkit_hash
    if config.present?
      config.select { |k,v| k.start_with? "action_" || k == "source" }
    else
      {}
    end
  end
end
