class Customer < ActiveRecord::Base
  has_many :charges
  accepts_nested_attributes_for :charges
end
