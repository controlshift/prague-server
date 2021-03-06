require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature ConfigController do

  before(:each) do
    Rails.cache.clear
    allow_any_instance_of(ConfigController).to receive(:country).and_return(nil)
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
  end

  let(:organization) {create(:organization, global_defaults: { currency: 'AUD' }) }

  it 'should respond with default settings for JSON request' do
    visit "/config/#{organization.slug}"
    expect(page.body).to eq(organization.global_defaults.merge(rates: { 'GBP' => 1.1234}, country: 'US').to_json)
    expect(page.response_headers['Content-Type']).to match /application\/javascript/
  end

  it 'should be able to handle a blank external request' do
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "")
    visit "/config/#{organization.slug}"
    expect(page.body).to eq(organization.global_defaults.merge(rates: nil, country: 'US').to_json)
  end

  context 'no geoip' do
    context 'a specified country' do
      let(:organization) {create(:organization, global_defaults: { country: 'AU', currency: 'USD'}) }

      it 'should use the supplied country' do
        visit "/config/#{organization.slug}"
        expect(JSON.parse(page.body)['country']).to eq('AU')
      end
    end

    it 'should default the country to US if none is supplied' do
      visit "/config/#{organization.slug}"
      expect(JSON.parse(page.body)['country']).to eq('US')
    end
  end
end
