require 'spec_helper'

describe ChargesController do

  before do
    StripeMock.start
  end

  describe 'POST create' do
    context 'with valid card_token and customer parameters' do
      let(:valid_customer_parameters) { { 'first_name' => 'Foo', 'last_name' => 'Bar', 'email' => 'foo@bar.com', 'country' => 'US', 'zip' => '90004'} }
      let(:valid_card_token) { StripeMock.generate_card_token(last4: '9191', exp_year: 2015) }

      it 'should save and process the customer' do
        CreateCustomerTokenWorker.should_receive(:perform_async)
        post :create, customer: valid_customer_parameters, card_token: valid_card_token
        customer = Customer.where(email: valid_customer_parameters['email']).first
        customer.should_not be_nil
        response.should be_success
      end
    end

    context 'if i don\'t pass the required parameters' do
      it 'should response with unprocessable entity' do
        post :create
        response.should be_unprocessable
      end
    end 
  end
end