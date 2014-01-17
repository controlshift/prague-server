class Charge < ActiveRecord::Base
  belongs_to :customer
  belongs_to :organization

  validates_presence_of :amount
  validates_presence_of :currency
end
