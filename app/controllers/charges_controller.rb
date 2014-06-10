class ChargesController < ApplicationController

  # Necessary for exposing the API
  skip_before_action :verify_authenticity_token, only: [ :create ]
  before_filter :authenticate_organization!, only: [:index]

  def create
    organization = Organization.find_by_slug(organization_slug_param)
    customer = Customer.new(customer_params)
    customer.status = organization.status
    charge = customer.charges.first
    charge.organization = organization
    charge.config = config_param
    charge.status = organization.status

    if customer.save
      CreateCustomerTokenWorker.perform_async(customer.id, card_token_param)
      render json: {}, status: :ok
    else
      render json: { error: customer.errors }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { error: "You must provide all of the required parameters. Check the documentation." }, status: :unprocessable_entity 
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :country, :zip, charges_attributes: [:currency, :amount, :pusher_channel_token])
  end

  def card_token_param
    params.require(:card_token)
  end

  def organization_slug_param
    params.require(:organization_slug)
  end

  def config_param
    params.require(:config).permit! if params[:config]
  end
end
