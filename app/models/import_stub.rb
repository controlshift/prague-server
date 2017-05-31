# == Schema Information
#
# Table name: import_stubs
#
#  id                :integer          not null, primary key
#  crm_id            :integer
#  payment_account   :string
#  donation_currency :string
#  created_at        :datetime
#  updated_at        :datetime
#

class ImportStub < ActiveRecord::Base
  belongs_to :crm

  validates :payment_account, presence: true
  validates :donation_currency, presence: true
  validates :crm, presence: true
end
