# == Schema Information
#
# Table name: import_stubs
#
#  id                :integer          not null, primary key
#  crm_id            :integer
#  payment_account   :string(255)
#  donation_currency :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class ImportStub < ActiveRecord::Base
  belongs_to :crm

  validates :payment_account, presence: true
  validates :donation_currency, presence: true
  validates :crm, presence: true
end
