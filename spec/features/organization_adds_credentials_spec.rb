require 'scenario_helper'

describe 'Organization adds CRM credentials' do
  before do
    login org
  end

  let(:org) { create(:organization) }
  it 'creates credentials for the first time', js: true do
    page.first(".credentials-form")[:id].should == "new_crm"
    fill_in 'Username', with: 'user'
    fill_in 'Password', with: 'password'
    fill_in 'Host', with: 'host'
    fill_in 'Donation page name', with: 'page1'
    first(".credentials-form").find("input[type='submit']").click
    wait_for_ajax
    Organization.last.crm.username.should == 'user'
    Organization.last.crm.platform.should == 'actionkit'
    Organization.last.crm.host.should == 'host'
    page.first(".credentials-form")[:id].should match(/edit_crm_/)
  end
end