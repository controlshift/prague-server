require 'spec_helper'

describe ImportStub do
  it { should validate_presence_of(:crm) }
  it { should validate_presence_of(:payment_account) }
  it { should validate_presence_of(:donation_currency) }
end