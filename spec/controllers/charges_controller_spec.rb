require 'scenario_helper'

describe ChargesController do
  let(:organization) { create(:organization) }

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

    context 'with parameters generated by the widget' do
      let(:params) {
        {
        'organization_slug' => organization.slug,
        'customer' =>
          {
            'charges_attributes' =>
              [
                {
                  'currency' => 'USD',
                  'amount' => 100
                }
              ],
            'first_name' => 'Nathan',
            'last_name' => 'Woodhull',
            'email' => 'woodhull@gmail.com',
            'country' => 'US'
          },
        'card_token' => 'tok_3srLe8OTLHfbqD',
        'config' => {
          'rates' => {
            'AED' => 3.673294,
            'AFN' => 56.09,
            'ALL' => 101.36241,
            'AMD' => 417.083,
            'ANG' => 1.78558,
            'AOA' => 97.7464,
            'ARS' => 8.010267,
            'AUD' => 1.071927,
            'AWG' => 1.78375,
            'AZN' => 0.784133,
            'BAM' => 1.416203,
            'BBD' => 2,
            'BDT' => 77.73449,
            'BGN' => 1.414194,
            'BHD' => 0.377248,
            'BIF' => 1549.495,
            'BMD' => 1,
            'BND' => 1.252621,
            'BOB' => 6.921639,
            'BRL' => 2.238569,
            'BSD' => 1,
            'BTC' => 0.0020838469,
            'BTN' => 60.356613,
            'BWP' => 8.758714,
            'BYR' => 9965.003333,
            'BZD' => 2.01742,
            'CAD' => 1.101964,
            'CDF' => 922.005333,
            'CHF' => 0.882908,
            'CLF' => 0.02351,
            'CLP' => 557.429105,
            'CNY' => 6.218311,
            'COP' => 1929.943333,
            'CRC' => 548.7641,
            'CUP' => 1.0013,
            'CVE' => 79.494079,
            'CZK' => 19.86565,
            'DJF' => 179.506,
            'DKK' => 5.403522,
            'DOP' => 43.15687,
            'DZD' => 78.73357,
            'EEK' => 11.631425,
            'EGP' => 6.997817,
            'ERN' => 14.952575,
            'ETB' => 19.47637,
            'EUR' => 0.723915,
            'FJD' => 1.83032,
            'FKP' => 0.595535,
            'GBP' => 0.595535,
            'GEL' => 1.7581,
            'GHS' => 2.773783,
            'GIP' => 0.595535,
            'GMD' => 39.64,
            'GNF' => 7027.913333,
            'GTQ' => 7.75989,
            'GYD' => 204.226249,
            'HKD' => 7.754371,
            'HNL' => 19.13711,
            'HRK' => 5.517347,
            'HTG' => 44.57786,
            'HUF' => 221.936199,
            'IDR' => 11436.95,
            'ILS' => 3.478898,
            'INR' => 60.32219,
            'IQD' => 1164.688333,
            'IRR' => 25315.666667,
            'ISK' => 111.886,
            'JEP' => 0.595535,
            'JMD' => 109.7451,
            'JOD' => 0.708066,
            'JPY' => 102.382601,
            'KES' => 86.91215,
            'KGS' => 54.421075,
            'KHR' => 4001.69,
            'KMF' => 356.232139,
            'KPW' => 900,
            'KRW' => 1037.916683,
            'KWD' => 0.281668,
            'KYD' => 0.827401,
            'KZT' => 182.287501,
            'LAK' => 8046.875,
            'LBP' => 1509.625,
            'LKR' => 130.688,
            'LRD' => 84.8349,
            'LSL' => 10.51364,
            'LTL' => 2.499078,
            'LVL' => 0.509068,
            'LYD' => 1.242703,
            'MAD' => 8.133152,
            'MDL' => 13.40058,
          },
          'stripepublickey' => "pk_live_TkBE6KKwIBdNjc3jocHvhyNx",
          'pusherpublickey' => "331ca3447b91e264a76f",
          'pathtoserver' => "https://www.takecharge.io",
          'imgpath' => "https://d2yuwrm8xcn0u8.cloudfront.net",
          'metaviewporttag' => "true",
          'org' => "nathan-controlshiftlabs-com",
          'seedamount' => 10,
          'seedvalues' => "50,100,200,300,400,500,600",
          'seedcurrency' => "USD"
          }
        }
      }

      let(:valid_card_token) { StripeMock.generate_card_token(last4: '9191', exp_year: 2015) }

      it 'should save and process the customer' do
        CreateCustomerTokenWorker.should_receive(:perform_async)
        post :create, params
        response.should be_success

        customer = Customer.where(email: params['customer']['email']).first
        customer.should_not be_nil
        customer.charges.should_not be_empty
        customer.charges.first.organization.should == organization
      end
    end

    context 'without the required parameters' do
      it 'should response with unprocessable entity' do
        post :create
        response.should be_unprocessable
      end
    end 
  end
end
