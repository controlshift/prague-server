require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature ConfigController do

  before(:each) do
    Rails.cache.clear
    ConfigController.any_instance.stub(:country).and_return(nil)
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
  end

  let(:organization) {create(:organization, global_defaults: { currency: 'AUD' }) }

  it 'should respond with default settings for JSON request' do
    visit "/config/#{organization.slug}"
    page.body.should == organization.global_defaults.merge(rates: { 'GBP' => 1.1234}, country: 'US').to_json
    page.response_headers['Content-Type'].should == 'application/javascript'
  end

  it 'should be able to handle a blank external request' do
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "")
    visit "/config/#{organization.slug}"
    page.body.should == organization.global_defaults.merge(rates: nil, country: 'US').to_json
  end

  context 'no geoip' do
    context 'a specified country' do
      let(:organization) {create(:organization, global_defaults: { country: 'AU' }) }

      it 'should use the supplied country' do
        visit "/config/#{organization.slug}"
        JSON.parse(page.body)['country'].should == 'AU'
      end
    end

    it 'should default the country to US if none is supplied' do
      visit "/config/#{organization.slug}"
      JSON.parse(page.body)['country'].should == 'US'
    end
  end
end