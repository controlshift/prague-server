class ChargesController < ApplicationController

  def create
    customer = Customer.new(customer_params)
    if customer.save
      CreateCustomerTokenWorker.perform_async(customer.id, card_token_param)
      render json: { customer_id: customer.id }, status: :ok
    else
      render json: { error: "Something went wrong. Try again." }, status: :unprocessable_entity 
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :country, :zip)
  end

  def card_token_param
    params.require(:card_token)
  end
end