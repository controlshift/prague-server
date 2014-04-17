# == Schema Information
#
# Table name: customers
#
#  id             :integer          not null, primary key
#  customer_token :string(255)
#  first_name     :string(255)
#  last_name      :string(255)
#  country        :string(255)
#  zip            :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Customer < ActiveRecord::Base
  has_many :charges, inverse_of: :customer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :country, presence: true
  validates :email, presence: true, email_format: true
  validates :zip, presence: true

  accepts_nested_attributes_for :charges
end
