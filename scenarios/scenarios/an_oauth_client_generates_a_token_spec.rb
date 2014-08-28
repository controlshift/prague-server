require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'OAuth Client Generates a token' do
  before do
    stub_request(:get, "https://api.stripe.com/v1/account").to_return(:status => 200, :body => fixture('account.json'), :headers => {})
    login org
  end

  let(:redirect_uri) { 'urn:ietf:wg:oauth:2.0:oob' }
  let!(:app) { create(:doorkeeper_application, redirect_uri: redirect_uri) }
  let!(:org) { create(:organization) }

  specify 'auth ok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    # start the OAuth flow
    url = client.auth_code.authorize_url(:redirect_uri => redirect_uri)
    visit url

    # authorize the app, and grab the token. Ordinarily this would be a redirect, but we're running in test mode.
    click_on 'Authorize'
    code = page.find("#authorization_code").text

    page.driver.post('/oauth/token', { :client_id => app.uid, client_secret: app.secret, code: code, grant_type: 'authorization_code', redirect_uri: redirect_uri  })
    page.driver.status_code.should eql 200
    token = JSON.parse(page.body)['access_token']

    # use the api token to get the organization's config
    response = OAuth2::AccessToken.new(client, token).get('/api/config')
    json = JSON.parse(response.body)
    expect(json['slug']).to eq(org.slug)
  end
end
