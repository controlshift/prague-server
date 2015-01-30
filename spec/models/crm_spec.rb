# == Schema Information
#
# Table name: crms
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  donation_page_name :string(255)
#  host               :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  platform           :string(255)
#  default_currency   :string(255)      default("USD")
#

require 'spec_helper'

describe Crm do
  let(:crm) { build(:crm, password: 'password') }

  specify 'it should keep an encrypted password and be able to fetch it' do
    crm.save!
    expect(crm.encrypted_password).to be_present
    expect(crm.encrypted_password).not_to eq 'password'
    crm.password = nil
    expect(crm.password).to be_nil
    crm.reload
    expect(crm.password).to eq 'password'
  end

  specify 'it should ignore a blank password on update' do
    crm.save!
    crm.update_attribute(:password, "")
    crm.reload
    expect(crm.password).to eq 'password'
    crm.update_attribute(:password, "password2")
    crm.reload
    expect(crm.password).to eq 'password2'
  end
end
