require File.dirname(__FILE__) + '/../scenario_helper.rb'

feature "Organization signs up" do
  before(:each) do |example|
    Organization.last.try :destroy
    Crm.last.try :destroy
  end
  context "when organization denies access to Stripe account" do
    it "redirects to new organization form" do
      OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
      visit "/auth/stripe_connect/callback"
      current_path.should == root_path
    end
  end

  context "when organization fills out the form correctly" do
    let(:auth_hash) { {
      'uid' => 'X',
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
      fill_in "organization[name]", with: "Sample"
      fill_in "organization[email]", with: "foo@bar.com"
      fill_in "organization[password]", with: "password"
      fill_in "organization[password_confirmation]", with: "password"
      click_button "Sign up"
      open_email Organization.last.email
      current_email.click_link "Confirm my account"
      expect(page).to have_content(Organization.last.name)
      slug = Organization.last.slug
      page.should have_text(slug)
      current_path.should == organization_path(slug)
    end

    let(:org) { create(:organization, access_token: nil, stripe_publishable_key: nil, stripe_user_id: nil) }
    it "allows the organization to fill out credentials" do
      visit root_path
      click_link "Sign in"
      expect(page).to have_content("Sign in")
      fill_in "organization[email]", with: org.email
      fill_in "organization[password]", with: "password"
      click_button "Sign in"
      expect(page).to have_content(org.name)
      page.find(".stripe-connect").click
      org.reload
      org.access_token.should == "X"
    end
  end
end
