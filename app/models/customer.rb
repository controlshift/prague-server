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
#  status         :string(255)      default("live")
#

class Customer < ActiveRecord::Base
  include LiveMode

  has_many :charges, inverse_of: :customer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :country, presence: true
  validates :email, presence: true, email_format: true

  accepts_nested_attributes_for :charges

  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end

  def self.find_or_initialize(customer_params, status: nil)
    customer = find_by_email(customer_params[:email].downcase)
    if customer.present? 
      customer.assign_attributes(customer_params.except(:charges_attributes))
    else
      customer = Customer.new(customer_params.except(:charges_attributes))
    end
    customer.status = status
    customer
  end

  def build_charge_with_params(charges_attributes, config: nil, organization: nil)
    charge = charges.build(charges_attributes.first)
    charge.config = config
    charge.organization = organization
    charge.status = organization.status
    charge
  end

  def to_hash
    {
      first_name: first_name,
      last_name: last_name,
      country: country,
      zip: zip,
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
