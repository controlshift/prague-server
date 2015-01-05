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

require 'spec_helper'

describe ImportStub do
  it { should validate_presence_of(:crm) }
  it { should validate_presence_of(:payment_account) }
  it { should validate_presence_of(:donation_currency) }
end
