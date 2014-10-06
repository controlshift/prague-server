class ChargesController < ApplicationController

  # Necessary for exposing the API
  skip_before_action :verify_authenticity_token, only: [ :create ]
  before_filter :authenticate_organization!, only: [:index]

  after_filter :cors_set_access_control_headers, only: [:create]

  def create
    organization = Organization.find_by_slug(organization_slug_param)
    if organization.present?
      customer = Customer.find_or_initialize(customer_params, status: organization.status)
      charge = customer.build_charge_with_params(customer_params[:charges_attributes], config: config_param, organization: organization)
      if params[:tags].present?
        params[:tags].each do |tag_string|
          charge.tags << Tag.find_or_create!(organization, tag_string)
        end
      end

      if customer.save
        CreateCustomerTokenWorker.perform_async(customer.id, card_token_param, charge.id)
        render json: {}, status: :ok
      else
        render json: { error: customer.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: "Organization: '#{organization_slug_param}' does not exist." }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { error: "You must provide all of the required parameters. Check the documentation." }, status: :unprocessable_entity 
  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :country, :zip, charges_attributes: [:currency, :amount, :pusher_channel_token, :status])
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
