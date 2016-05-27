require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature 'OAuth Client Generates a token' do
  let(:redirect_uri) { 'urn:ietf:wg:oauth:2.0:oob' }
  let!(:app) { create(:doorkeeper_application, redirect_uri: redirect_uri) }
  let(:org) { create(:organization) }
  let(:org2) { create(:organization) }
  let!(:user) { create(:confirmed_user, organization: org)}
  let!(:user2) { create(:confirmed_user, organization: org2)}

  let(:client) do
    OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  end

  before(:each) do
    stub_request(:get, "https://api.stripe.com/v1/accounts/x").to_return(:status => 200, :body => fixture('account.json'), :headers => {})
  end

  context 'while signed in' do
    before do
      login user
    end

    specify 'auth ok' do
      # start the OAuth flow
      url = client.auth_code.authorize_url(:redirect_uri => redirect_uri)
      visit url

      # authorize the app, and grab the token. Ordinarily this would be a redirect, but we're running in test mode.
      click_on 'Authorize'
      code = page.find("#authorization_code").text

      # we need to do this hack, because I'm not sure how to tell OAuth2::Client to use the rack adapter on this step.
      page.driver.post('/oauth/token', { :client_id => app.uid, client_secret: app.secret, code: code, grant_type: 'authorization_code', redirect_uri: redirect_uri  })
      expect(page.driver.status_code).to eql(200)
      token = JSON.parse(page.body)['access_token']

      # use the api token to get the organization's config
      response = OAuth2::AccessToken.new(client, token).get('/api/config')
      json = JSON.parse(response.body)
      expect(json['slug']).to eq(org.slug)

      # sign in as the other user.
      logout user
      login user2

      # start the OAuth flow
      url = client.auth_code.authorize_url(:redirect_uri => redirect_uri)
      visit url

      # authorize the app, and grab the token. Ordinarily this would be a redirect, but we're running in test mode.
      click_on 'Authorize'
      code = page.find("#authorization_code").text

      # we need to do this hack, because I'm not sure how to tell OAuth2::Client to use the rack adapter on this step.
      page.driver.post('/oauth/token', { :client_id => app.uid, client_secret: app.secret, code: code, grant_type: 'authorization_code', redirect_uri: redirect_uri  })
      expect(page.driver.status_code).to eql(200)
      token = JSON.parse(page.body)['access_token']

      # use the api token to get the organization's config
      response = OAuth2::AccessToken.new(client, token).get('/api/config')
      json = JSON.parse(response.body)

      # verify that we now get the other user's configuration
      expect(json['slug']).to eq(org2.slug)

      # the token authenticates access to the organization, not the user, so deleting the users should have no effect.
      logout user2

      user.destroy
      user2.destroy

      # use the api token to get the organization's config
      response = OAuth2::AccessToken.new(client, token).get('/api/config')
      json = JSON.parse(response.body)

      # verify that we now get the other user's configuration
      expect(json['slug']).to eq(org2.slug)
    end
  end

  context 'while not signed in' do
    it 'should be redirected to sign in and then where you were trying to go' do
      # start the OAuth flow
      url = client.auth_code.authorize_url(:redirect_uri => redirect_uri)
      visit url

      expect(page).to have_content('Sign In')
      expect(page.current_path).to eq(new_user_session_path)
      within '#new_user' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'password'
        click_on 'Sign in'
      end
      expect(page).to have_content 'Authorize'
    end
  end

  context 'without a stripe access_token' do
    let(:org) { create(:organization, access_token: nil) }
    it 'should be redirected to sign in and then prompt you to connect to stripe' do
      # start the OAuth flow
      url = client.auth_code.authorize_url(:redirect_uri => redirect_uri)
      visit url

      expect(page).to have_content('Sign In')
      expect(page.current_path).to eq(new_user_session_path)
      within '#new_user' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'password'
        click_on 'Sign in'
      end
      expect(page).to have_content 'To get started, you first must connect with Stripe'
    end
  end
end
