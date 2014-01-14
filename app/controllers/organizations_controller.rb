class OrganizationsController < ApplicationController
  def create
    @organization = Organization.new
    @organization.apply_omniauth(request.env['omniauth.auth'])
    flash[:notice] = @organization.save ? "You are signed up!" : "Something went wrong."
  end

  def new
    @organization = Organization.new
  end
end
