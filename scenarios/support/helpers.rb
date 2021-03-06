module HelperMethods
  include Warden::Test::Helpers

  def login(user)
    Warden.test_mode!
    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "password"
    click_button "Sign in"
    expect(page).to have_content user.organization.name
  end

  def logout(user)
    visit root_path
    click_on user.email
    click_on 'Sign out'
  end
end

RSpec.configure do |config|
  config.include HelperMethods
end