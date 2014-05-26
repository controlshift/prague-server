module HelperMethods
  include Warden::Test::Helpers
  def login organization
    Warden.test_mode!
    visit new_organization_session_path
    fill_in "organization[email]", with: organization.email
    fill_in "organization[password]", with: "password"
    click_button "Sign in"
    expect(page).to have_content organization.name
  end
end

RSpec.configure do |config|
  config.include HelperMethods
end