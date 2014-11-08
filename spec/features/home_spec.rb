require 'spec_helper'

feature 'Visiting home page' do
  scenario 'as an anonymous user' do
    visit root_path
    expect(page).to have_selector('h1', text: 'Smart Donations Done Right.')
    expect(page).to have_link('Sign in', href: new_user_session_path)
    expect(page).to have_link('Get Started', href: new_user_registration_path)
  end
end