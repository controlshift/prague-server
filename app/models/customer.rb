class Customer < ActiveRecord::Base
  has_many :charges, inverse_of: :customer

  accepts_nested_attributes_for :charges
end
