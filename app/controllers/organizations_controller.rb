class OrganizationsController < ApplicationController
  before_action :load_organization, except: [:new, :create, :omniauth_failure]

  def show
    begin
      @account = Stripe::Account.retrieve stripe_access_token
    rescue SocketError, Stripe::AuthenticationError => e
      Rails.logger.warn e
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.users << current_user
    if @organization.save
      redirect_to @organization, :organization_created => 'true'
    else
      render :new
    end
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

  def toggle
    @organization = current_organization
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
    @organization.update_attributes(stripe_user_id: nil, stripe_publishable_key: nil, access_token: nil, refresh_token: nil, stripe_live_mode: nil)
    redirect_to @organization
  end

  def omniauth_failure
    redirect_to root_path, notice: "Something went wrong. Please try again."
  end

  private

  def load_organization
    authorize! :manage, current_organization
  end

  def current_organization
    @organization ||= Organization.where(slug: params[:id]).first!
  end

  def organization_params
    params.require(:organization).permit(:name)
  end

  def toggle_params
    params.require(:organization).permit(:testmode)
  end

  def global_defaults_param
    params.require(:organization).permit(:currency, :seedamount, :redirectto, :seedvalues, :thank_you_text, :testmode, :country, :contact_email)
  end
end
