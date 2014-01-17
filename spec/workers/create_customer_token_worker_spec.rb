require 'spec_helper'

describe CreateCustomerTokenWorker do
  
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 2015) }
  let(:customer) { create(:customer, customer_token: nil) }

  describe '#perform' do
    before do
      Sidekiq::Testing.inline!
      StripeMock.start
    end

    specify 'it should update customer with a token' do
      CreateCustomerTokenWorker.perform_async(customer.id, card_token, "org")
      customer.reload
      customer.customer_token.should match(/cus_.*/)
    end
  end
end