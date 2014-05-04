class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!, only: [:update, :show]

  def show
    @organization = current_organization
    @crm = current_organization.crm || current_organization.build_crm
  end

  def update
    @organization = current_organization
    if @organization.update_attributes(global_defaults_param)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def omniauth_failure
    redirect_to root_path, notice: "Something went wrong. Please try again."
  end

  private 

  def global_defaults_param
    params.require(:organization).permit(:currency, :seedamount, :redirectto, :seedvalues)
  end
end
