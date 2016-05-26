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

  it 'creates credentials for the first time', js: true do
    click_on 'orgMenu'
    click_on 'Settings'
    select 'AUD', from: 'organization[currency]'
    fill_in 'organization_seedamount', with: '10'
    fill_in 'organization_seedvalues', with: '100,200,300'
    fill_in 'organization_thank_you_text', with: "Thanks for contributing to our cause"
    first("#global-defaults-form").find("input[type='submit']").click
    wait_for_ajax
    expect(page).to have_selector('.global-defaults-success', visible: true)
    organization = Organization.last
    expect(organization.currency).to eq('AUD')
    expect(organization.seedamount).to eq('10')
    expect(organization.seedvalues).to eq('100,200,300')
    expect(organization.thank_you_text).to eq('Thanks for contributing to our cause')
  end
end
