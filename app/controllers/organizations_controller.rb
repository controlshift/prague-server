class OrganizationsController < ApplicationController
  def create
    @organization = Organization.new
    @organization.apply_omniauth(request.env['omniauth.auth'])
    unless @organization.save
      render :new, notice: "Something went wrong. Please try again."
    end
  end

  def new
    @organization = Organization.new
  end

  def omniauth_failure
    redirect_to new_organization_path, notice: "Something went wrong. Please try again."
  end
end
