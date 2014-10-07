require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'Organization adds CRM credentials' do
  before do
    StripeMock.start
    login org
  end

  after do
    StripeMock.stop
  end

  let(:org) { create(:organization) }
  it 'creates AK credentials for the first time', js: true do
    # Set up AK
    select 'ActionKit', from: 'crm_platform'
    page.first(".credentials-form", visible: true)[:id].should == "crm-form-actionkit"
    fill_in 'crm_username', with: 'user'
    fill_in 'crm_password', with: 'password'
    fill_in 'crm_host', with: 'host'
    fill_in 'crm_donation_page_name', with: 'page1'
    fill_in 'crm_default_currency', with: 'USD'
    click_link "Add Import Stub"
    fill_in 'Payment account', with: "GBP Import Stub"
    fill_in 'Donation currency', with: "GBP"
    first(".credentials-form", visible: true).find("input[type='submit']").click
    wait_for_ajax
    page.should have_selector('.crm-form-success', visible: true)

    # Check that the settings got set correctly
    crm = Organization.last.crm
    crm.username.should == 'user'
    crm.platform.should == 'actionkit'
    crm.host.should == 'host'
    crm.import_stubs.first.payment_account.should == 'GBP Import Stub'
    crm.import_stubs.first.donation_currency.should == 'GBP'

    # Remove the import stub
    fill_in 'crm_password', with: 'password'
    click_link "X"
    expect(page).not_to have_content('Payment accout')
    first(".credentials-form", visible: true).find("input[type='submit']").click
    sleep 1  # for some reason wait_for_ajax isn't doing it
    wait_for_ajax
    page.should have_selector('.crm-form-success', visible: true)
    crm.reload.import_stubs.should be_empty
  end
end
