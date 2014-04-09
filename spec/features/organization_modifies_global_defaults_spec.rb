require 'spec_helper'

describe 'Organization adds CRM credentials' do
  before do
    login
  end

  it 'creates credentials for the first time', js: true do
    select 'AUD', from: 'organization[global_defaults][currency]'
    first(".global-defaults-form").find("input[type='submit']").click
    wait_for_ajax
    Organization.last.global_defaults['currency'].should == 'AUD'
  end
end
