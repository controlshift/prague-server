class AuthenticationsController < ApplicationController
  def create
    current_organization.apply_omniauth(request.env['omniauth.auth'])
    if current_organization.save
      # if we need to return to some other location, for example Agra, do it here.
      stored_loc = stored_location_for(current_user)
      if stored_loc
        redirect_to stored_loc
      else
        redirect_to current_organization
      end
    else
      render :new, notice: "Something went wrong. Please try again."
    end
  end
end
