class OrganizationsController < ApplicationController
  after_action :verify_authorized

  def show
    @organization = Organization.find_by_slug(params[:id])
    authorize @organization
    begin
      @account = Stripe::Account.retrieve @organization.access_token if @organization.access_token.present?
    rescue SocketError, Stripe::AuthenticationError => e
      Rails.logger.warn e
    end
    @crm = @organization.crm || @organization.build_crm
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    @organization.users << current_user
    if @organization.save
      redirect_to @organization
    else
      render :new
    end
  end

  def update
    @organization = current_organization
    authorize @organization
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

  def toggle
    @organization = current_organization
    authorize @organization
    if @organization.update_attributes(toggle_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def deauthorize
    @organization = current_organization
    authorize @organization
    @organization.update_attributes(stripe_user_id: nil, stripe_publishable_key: nil, access_token: nil, refresh_token: nil, stripe_live_mode: nil)
    redirect_to @organization
  end

  def omniauth_failure
    authorize Organization.new
    redirect_to root_path, notice: "Something went wrong. Please try again."
  end

  private

  def current_organization
    current_user.organization
  end

  def organization_params
    params.require(:organization).permit(:name)
  end

  def toggle_params
    params.require(:organization).permit(:testmode)
  end

  def global_defaults_param
    params.require(:organization).permit(:currency, :seedamount, :redirectto, :seedvalues, :thank_you_text, :testmode)
  end
end
