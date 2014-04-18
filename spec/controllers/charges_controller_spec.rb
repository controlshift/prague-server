require 'spec_helper'

describe ChargesController do

  before do
    StripeMock.start
  end

  describe 'POST create' do
    context 'with valid card_token and customer parameters' do
      let(:valid_customer_parameters) { 
        { 'first_name' => 'Foo', 
          'last_name' => 'Bar', 
          'email' => 'foo@bar.com', 
          'country' => 'US', 
          'zip' => '90004',
          'charges_attributes' => [
            'amount' => '1000',
            'currency' => 'usd'
          ]
        }
      }
      let(:valid_card_token) { StripeMock.generate_card_token(last4: '9191', exp_year: 2015) }
      let(:organization) { create(:organization) }

      it 'should save and process the customer' do
        CreateCustomerTokenWorker.should_receive(:perform_async)
        post :create, customer: valid_customer_parameters, card_token: valid_card_token, organization_slug: organization.slug
        customer = Customer.where(email: valid_customer_parameters['email']).first
        customer.should_not be_nil
        customer.charges.should_not be_empty
        customer.charges.first.organization.should == organization
        response.should be_success
      end

      let(:config_parameters) { { 'ak_test' => 'foo' } }

      it 'should allow me to pass arbitrary config parameters' do
        post :create, customer: valid_customer_parameters, card_token: valid_card_token, organization_slug: organization.slug, config: config_parameters
        customer = Customer.where(email: valid_customer_parameters['email']).first
        charge = customer.charges.first
        charge.config['ak_test'].should == 'foo'
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
