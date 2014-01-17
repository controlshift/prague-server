class Charge < ActiveRecord::Base
  belongs_to :customer
  belongs_to :organization

  validates_presence_of :amount
  validates_presence_of :currency

  before_create :build_pusher_channel_token

  def build_pusher_channel_token
    self.pusher_channel_token = SecureRandom.base64
  end
end
