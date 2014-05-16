require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature ConfigController do

  before(:each) do
    Rails.cache.clear
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
  end

  let(:organization) {create(:organization, global_defaults: { currency: 'AUD' }) }

  it 'should respond with default settings for JSON request' do
    visit "/config/#{organization.slug}"
    page.body.should == organization.global_defaults.merge(rates: { 'GBP' => 1.1234}, country: nil).to_json
  end

  it 'should be able to handle a blank external request' do
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "")
    visit "/config/#{organization.slug}"
    page.body.should == organization.global_defaults.merge(rates: nil, country: nil).to_json
  end
end