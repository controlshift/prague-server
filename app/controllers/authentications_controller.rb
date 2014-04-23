class AuthenticationsController < ApplicationController
  def create
    current_organization.apply_omniauth(request.env['omniauth.auth'])
    if current_organization.save
      redirect_to current_organization
    else
      render :new, notice: "Something went wrong. Please try again."
    end
  end
end