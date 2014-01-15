class OrganizationsController < ApplicationController
  def create
    @organization = Organization.new
    @organization.apply_omniauth(request.env['omniauth.auth'])
    if @organization.save
      redirect_to @organization
    else
      render :new, notice: "Something went wrong. Please try again."
    end
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def omniauth_failure
    redirect_to new_organization_path, notice: "Something went wrong. Please try again."
  end
end
