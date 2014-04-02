class OrganizationsController < ApplicationController
  before_filter :sign_in_if_organization_exists, only: [:create]
  before_filter :authenticate_organization!, only: [:show]

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
end
