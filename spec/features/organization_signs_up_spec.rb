require 'spec_helper'

describe "Organization signs up" do
  context "when organization denies access to Stripe account" do
    it "redirects to new organization form" do
      OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
      visit "/auth/stripe_connect/callback"
      current_path.should == new_organization_path
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
      visit new_organization_path
      click_link 'stripe-connect-link'
      slug = Organization.last.slug
      current_path.should == organization_path(slug)
      page.should have_text(slug)
    end
  end
end
