module HelperMethods
  def login user
    sign_in user
    visit user_path(user)
  end
end