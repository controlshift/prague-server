class ImportStub < ActiveRecord::Base
  belongs_to :crm

  validates :payment_account, :donation_currency, presence: true
end
