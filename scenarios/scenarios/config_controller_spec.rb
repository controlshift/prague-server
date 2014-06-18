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
    page.body.should == organization.global_defaults.merge(rates: { 'GBP' => 1.1234})
      .merge(error_messages: I18n.t('error_messages', locale: 'en')).merge(fields: I18n.t('fields', locale: 'en')).merge(country: nil).to_json
    page.response_headers['Content-Type'].should == 'application/javascript'
  end

  it 'should be able to handle a blank external request' do
    stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "")
    visit "/config/#{organization.slug}"
    page.body.should == organization.global_defaults.merge(rates: nil)
      .merge(error_messages: I18n.t('error_messages', locale: 'en')).merge(fields: I18n.t('fields', locale: 'en')).merge(country: nil).to_json
  end
end