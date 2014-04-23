require 'spec_helper'

describe 'Organization adds CRM credentials' do
  before do
    org
    login org
  end

  let(:org) { create(:organization) }
  
  it 'creates credentials for the first time', js: true do
    select 'AUD', from: 'organization[global_defaults][currency]'
    fill_in 'organization_global_defaults_seedamount', with: '10'
    fill_in 'organization_global_defaults_seedvalues', with: '100,200,300'
    first(".global-defaults-form").find("input[type='submit']").click
    wait_for_ajax
    organization = Organization.last
    organization.currency.should == 'AUD'
    organization.seedamount.should == '10'
    organization.seedvalues.should == '100,200,300'
  end
end
