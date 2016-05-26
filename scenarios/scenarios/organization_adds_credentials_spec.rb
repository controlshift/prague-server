require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'Organization adds CRM credentials' do
  before do
    StripeMock.start
    login user
  end

  after do
    StripeMock.stop
  end

  let(:account) { Stripe::Account.create }
  let(:org) { create(:organization, stripe_user_id: account.id) }
  let(:user) { create(:confirmed_user, organization: org)}

  it 'creates AK credentials for the first time', js: true do
    click_on 'orgMenu'
    click_on 'Settings'
    # Set up AK
    click_on 'CRM'
    find("li", text: "ActionKit").click
    fill_in 'crm_username', with: 'user'
    fill_in 'crm_password', with: 'password'
    fill_in 'crm_host', with: 'www.google.com'
    fill_in 'crm_donation_page_name', with: 'page1'
    fill_in 'crm_default_currency', with: 'USD'
    find("input[type='submit']").click
    wait_for_ajax

    # Check that the settings got set correctly
    crm = Organization.last.crm
    expect(crm.username).to eq('user')
    expect(crm.platform).to eq('actionkit')
    expect(crm.host).to eq('www.google.com')
  end

  it 'creates BSD credentials for the first time', js: true do
    click_on 'orgMenu'
    click_on 'Settings'

    # Set up BSD
    click_on 'CRM'
    find("li", text: "Blue State Digital").click
    fill_in 'crm_username', with: 'API Key'
    fill_in 'crm_password', with: 'API Secret'
    fill_in 'crm_host', with: 'www.google.com'
    fill_in 'crm_default_currency', with: 'USD'
    find("input[type='submit']").click
    wait_for_ajax

    # Check that the settings got set correctly
    crm = Organization.last.crm
    expect(crm.username).to eq('API Key')
    expect(crm.platform).to eq('bluestate')
    expect(crm.host).to eq('www.google.com')
    expect(crm.import_stubs).to be_empty
  end
end
