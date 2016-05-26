require 'spec_helper'

feature 'User signs in' do
  let(:user) { create(:user, organization: organization) }
  let(:organization) { create(:organization) }

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

    scenario 'when already signed in' do
      sign_in_with(email: user.email, password: user.password)
      visit new_user_session_path
      expect(page).to have_content('You are already signed in')
    end

    scenario 'without organization' do
      sign_in_with(email: user.email, password: user.password)
      expect(page).to have_content('Signed in successfully')
      expect(page).to have_content('Create your organization')
    end

    context 'with organization' do
      let(:user) { create(:user_with_organization) }
      let(:organization) { user.organization }
      let(:account) { Stripe::Account.create  }

      before(:each) do
        StripeMock.start
        organization.stripe_user_id = account.id
        organization.save!
      end

      after(:each) do
        StripeMock.stop
      end

      scenario 'sees dashboard' do
        sign_in_with(email: user.email, password: user.password)
        expect(page).to have_content("The slug you will use for your organization is #{organization.slug}")
      end
    end
  end
end
