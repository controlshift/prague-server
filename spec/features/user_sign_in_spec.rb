require 'spec_helper'

feature 'User signs in' do
  let(:user) { create(:user) }

  scenario 'with invalid email' do
    sign_in_with(email: 'invalid@example.com', password: user.password)
    expect(page).to have_content('Invalid email or password')
  end

  scenario 'with invalid password' do
    sign_in_with(email: user.email, password: 'invalid')
    expect(page).to have_content('Invalid email or password')
  end

  context 'as unconfirmed user' do
    scenario 'with valid credentials' do
      sign_in_with(email: user.email, password: user.password)
      expect(page).to have_content('You have to confirm your account before continuing')
    end
  end

  context 'as confirmed user' do
    let(:user) { create(:confirmed_user) }

    scenario 'with valid credentials' do
      sign_in_with(email: user.email, password: user.password)
      expect(page).to have_content('Signed in successfully')
    end

    scenario 'when already signed in' do
      sign_in_with(email: user.email, password: user.password)
      visit new_user_session_path
      expect(page).to have_content('You are already signed in')
    end
  end
end