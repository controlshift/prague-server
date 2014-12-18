require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'Organization adds CRM credentials' do
  before do
    StripeMock.start
    login user
  end

  after do
    StripeMock.stop
  end

  let(:org) { create(:organization) }
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
    page.should have_selector('.global-defaults-success', visible: true)
    organization = Organization.last
    organization.currency.should == 'AUD'
    organization.seedamount.should == '10'
    organization.seedvalues.should == '100,200,300'
    organization.thank_you_text.should == "Thanks for contributing to our cause"
  end
end
