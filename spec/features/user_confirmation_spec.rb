require 'spec_helper'

feature 'User confirms his account' do
  scenario 'as an anonymous user with invalid token' do
    visit user_confirmation_url(confirmation_token: 'zzz')
    expect(page).to have_content('Confirmation token is invalid')
    expect(page).to have_field('Email')
    expect(page).to have_button('Resend instructions')
  end
end