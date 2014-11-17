module Features
  module UserHelpers
    def sign_up_with(email: '', password: '', password_confirmation: '', organization: '')
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password Confirmation', with: password_confirmation
      fill_in 'Organization', with: organization
      click_button 'Sign up'
    end

    def sign_in_with(email: '', password: '')
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end
  end
end