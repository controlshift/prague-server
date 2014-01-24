class Charge < ActiveRecord::Base
  belongs_to :customer
  belongs_to :organization

  validates :amount, :currency, :customer, :organization, presence: true

  before_create :build_pusher_channel_token

  def build_pusher_channel_token
    self.pusher_channel_token = Array.new(24){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end
end
