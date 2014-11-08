require 'spec_helper'

feature 'User signs up' do
  scenario 'with valid creadentials' do
    sign_up_with(email: 'user@example.com', password: '12345678', password_confirmation: '12345678')
    expect(page).to have_content('A message with a confirmation link has been sent to your email address.')
  end

  scenario 'without email' do
    sign_up_with(password: '12345678', password_confirmation: '12345678')
    expect(page).to have_content('Email can\'t be blank')
  end

  scenario 'with already taken email' do
    @user = User.create!(email: 'taken@example.com', password: '12345678', password_confirmation: '12345678')
    sign_up_with(email: @user.email, password: '12345678', password_confirmation: '12345678')
    expect(page).to have_content('Email has already been taken')
  end

  scenario 'without password' do
    sign_up_with(email: 'user@example.com', password_confirmation: '12345678')
    expect(page).to have_content('Password can\'t be blank')
  end

  scenario 'with too short password' do
    sign_up_with(email: 'user@example.com', password: '1234567', password_confirmation: '1234567')
    expect(page).to have_content('Password is too short')
  end

  scenario 'with password not matching password confirmation' do
    sign_up_with(email: 'user@example.com', password: '12345678', password_confirmation: '87654321')
    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end
end