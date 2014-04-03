require 'spec_helper'

describe 'Organization adds CRM credentials' do
  before do
    login
  end

  it 'creates credentials for the first time', js: true do
    fill_in 'Username', with: 'user'
    fill_in 'Password', with: 'password'
    fill_in 'Host', with: 'host'
    fill_in 'Donation page name', with: 'page1'
    page.find("input[type='submit']").click
    wait_for_ajax
    Organization.last.crm.username.should == 'user'
    Organization.last.crm.host.should == 'host'
    page.first("form")[:id].should == "edit_crm_1"
  end
end