class OrganizationsController < ApplicationController
  before_filter :sign_in_if_organization_exists, only: [:create]
  before_filter :authenticate_organization!, only: [:update]
  before_filter :authenticate_unless_json, only: [:show]

  def create
    @organization = Organization.new
    @organization.apply_omniauth(request.env['omniauth.auth'])
    if @organization.save
      OrganizationStripeInformationWorker.new.perform(@organization.id, true) && @organization.reload
      sign_in @organization
      redirect_to @organization
    else
      render :new, notice: "Something went wrong. Please try again."
    end
  end

  def show
    @crm = current_organization.crm || current_organization.build_crm
  end

  def new
    @organization = Organization.new
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

  def sign_in_if_organization_exists
    organization = Organization.find_for_stripe_oauth(request.env['omniauth.auth'])
    if organization.present?
      sign_in_and_redirect organization, event: :authentication
    end
  end

  def after_sign_in_path_for resource
    organization_path(current_organization)
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
