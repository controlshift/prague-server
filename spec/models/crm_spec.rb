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
end