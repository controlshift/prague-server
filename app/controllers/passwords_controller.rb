class PasswordsController < Devise::PasswordsController
  skip_after_action :verify_authorized
end