require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'Organization adds CRM credentials' do
  before do
    login org
  end

  let(:org) { create(:organization) }
  it 'creates credentials for the first time', js: true do
    page.first(".credentials-form")[:id].should == "crm-form"
    select 'ActionKit', from: 'crm_platform'
    fill_in 'crm_username', with: 'user'
    fill_in 'crm_password', with: 'password'
    fill_in 'crm_host', with: 'host'
    fill_in 'crm_donation_page_name', with: 'page1'
    first(".credentials-form").find("input[type='submit']").click
    wait_for_ajax
    page.should have_selector('.crm-form-success', visible: true)

    Organization.last.crm.username.should == 'user'
    Organization.last.crm.platform.should == 'actionkit'
    Organization.last.crm.host.should == 'host'
  end
end