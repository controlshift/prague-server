require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature "Organization signs up" do
  before(:each) do
    Organization.last.try :destroy
    Crm.last.try :destroy
    StripeMock.start
  end

  after(:each) do
    StripeMock.stop
  end

  let(:org) { create(:organization, access_token: nil, stripe_publishable_key: nil, stripe_user_id: nil) }
  let(:user) { create(:confirmed_user, organization: org)}

  context "when organization denies access to Stripe account" do
    before do
      login user
    end

    it "redirects to new organization form" do
      OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
      visit "/auth/stripe_connect/callback"
      expect(current_path).to eq(root_path)
    end
  end

  context "when organization fills out the form correctly" do
    let(:account) { Stripe::Account.create }
    let(:auth_hash) { {
      'uid' => account.id,
      'info' => { 'stripe_publishable_key' => 'X' },
      'credentials' => { 'token' => 'X' }
    } }

    before do
      OmniAuth.config.mock_auth[:stripe_connect] = auth_hash
    end

    it "redirects to the show page and exposes the organization's API slug" do
      visit root_path
      page.first('#get-started').click
      expect(page).to have_content("Sign up")
      fill_in "user[organization_attributes][name]", with: "Sample"
      fill_in "user[email]", with: "foo@bar.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button "Sign up"
      open_email User.last.email
      current_email.click_link "Confirm my account"
      expect(page).to have_content(Organization.last.name)
      slug = Organization.last.slug
      expect(page).to have_text(slug)
      expect(current_path).to eq(organization_path(slug))
    end

    it "allows the organization to fill out credentials" do
      visit root_path
      click_link "Sign in"
      expect(page).to have_content("Sign in")
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: "password"
      click_button "Sign in"
      expect(page).to have_content(org.name)
      expect(current_path).to eq(organization_path(org.slug))
      page.find("#stripe-connect-modal-link").click
      org.reload
      expect(org.access_token).to eq('X')
    end
  end
end
