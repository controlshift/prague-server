module HelperMethods
  include Warden::Test::Helpers
  def login organization
    Warden.test_mode!
    login_as(organization)
    visit organization_path(organization)
    expect(page).to have_content organization.name
  end
end

RSpec.configure do |config|
  config.include HelperMethods
end