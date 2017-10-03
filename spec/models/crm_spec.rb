# == Schema Information
#
# Table name: crms
#
#  id                    :integer          not null, primary key
#  organization_id       :integer
#  donation_page_name    :string
#  host                  :string
#  username              :string
#  created_at            :datetime
#  updated_at            :datetime
#  platform              :string
#  default_currency      :string           default("USD")
#  encrypted_password    :string
#  encrypted_password_iv :string
#

require 'spec_helper'

describe Crm do
  let(:crm) { build(:crm, password: 'password') }
  context 'stubbed resolv' do
    before(:each) do
      allow_any_instance_of(Resolv::DNS).to receive(:getaddress)
    end

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

    it { should allow_value('www.google.com').for(:host) }
    it { should_not allow_value('https://www.google.com/').for(:host) }
  end
  it 'should validate the hostname' do
    expect_any_instance_of(Resolv::DNS).to receive(:getaddress).and_raise(Resolv::ResolvError.new "resolv error")
    expect(crm.valid?).to be_falsey
    expect(crm.errors[:host]).to eq(['resolv error'])
  end
end
