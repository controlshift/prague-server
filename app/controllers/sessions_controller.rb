class SessionsController < ApplicationController
  def destroy
    sign_out(current_organization)
    redirect_to new_organization_path
  end
end
