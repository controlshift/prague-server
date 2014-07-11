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
#

require 'spec_helper'

describe Crm do
  let(:crm) { build(:crm, password: 'password') }

  specify 'it should keep an encrypted password and be able to fetch it' do
    crm.save!
    crm.encrypted_password.should be_present
    crm.encrypted_password.should_not == 'password'
    crm.password = nil
    crm.password.should == nil
    crm.reload
    crm.password.should == 'password'
  end

  specify 'it should ignore a blank password on update' do
    crm.save!
    crm.update_attribute(:password, "")
    crm.reload
    crm.password.should == 'password'
    crm.update_attribute(:password, "password2")
    crm.reload
    crm.password.should == 'password2'
  end
end
