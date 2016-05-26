require 'spec_helper'

feature 'User signs up' do
  scenario 'with valid creadentials' do
    sign_up_with(email: 'user@example.com', password: '12345678', password_confirmation: '12345678')
    expect(page).to have_content('A message with a confirmation link has been sent to your email address.')
    expect(page).to have_content('Smart Donations Done Right')
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

  context 'creates an organization' do
    scenario 'with valid name' do
      sign_up_with(email: 'user@example.com', password: '12345678', password_confirmation: '12345678', organization: 'Umbrella Corp.')
      expect(page).to have_content('A message with a confirmation link has been sent to your email address.')
      expect(page).to have_content('Smart Donations Done Right')
    end

    scenario 'with already taken name' do
      organization = create(:organization)
      sign_up_with(email: 'user@example.com', password: '12345678', password_confirmation: '12345678', organization: organization.name)
      expect(page).to have_content('Organization name has already been taken')
    end
  end

  context 'after being invited to the organization' do
    let(:sender) { create(:user_with_organization) }
    let(:invitation) { create(:invitation, sender: sender, organization: sender.organization, recipient_email: 'rec@mail.com') }
    let(:account) { Stripe::Account.create }

    before(:each) do
      StripeMock.start
      sender.organization.stripe_user_id = account.id
      sender.organization.save!
    end

    after(:each) do
      StripeMock.stop
    end


    scenario 'with valid credentials' do
      visit new_user_registration_path(invitation_token: invitation.token)
      fill_in 'Password', with: '12345678'
      fill_in 'Password Confirmation', with: '12345678'
      click_button 'Sign up'
      expect(page).to have_content(sender.organization.name)
    end

    scenario 'with invalid token' do
      visit new_user_registration_path(invitation_token: 'invalidtoken')
      expect(page).to have_content('Couldn\'t find invitation')
      expect(page).to have_content('Sign up')
    end
  end
end
