class OrganizationsController < ApplicationController
  before_filter :authenticate_organization!, only: [:update]
  before_filter :authenticate_unless_json, only: [:show]

  def show
    @crm = current_organization.crm || current_organization.build_crm
  end

  def update
    if current_organization.update_attribute(:global_defaults, global_defaults_param[:global_defaults])
      render :partial => 'organizations/global_defaults_form', :content_type => 'text/html'
    else
      render json: current_organization, status: :bad_request
    end
  end

  def omniauth_failure
    redirect_to new_organization_path, notice: "Something went wrong. Please try again."
  end

  private 

  def global_defaults_param
    params.require(:organization).tap do |whitelisted|
      whitelisted[:global_defaults] = params[:organization][:global_defaults]
    end
  end

  def authenticate_unless_json
    if request.format == :json
      render json: Organization.global_defaults_for_slug(params[:id]), callback: params[:callback]
    else
      authenticate_organization!
    end
  end
end
