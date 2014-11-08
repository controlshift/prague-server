module Features
  module SessionHelpers
    def sign_up_with(email: '', password: '', password_confirmation: '')
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password Confirmation', with: password_confirmation
      click_button 'Sign up'
    end
  end
end