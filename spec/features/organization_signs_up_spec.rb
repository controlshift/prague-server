require 'spec_helper'

describe "Organization signs up" do
  context "when organization denies access to Stripe account" do
    it "redirects to new organization form" do
      OmniAuth.config.mock_auth[:stripe_connect] = :access_denied
      visit "/auth/stripe_connect/callback"
      current_path.should == new_organization_path
    end
  end
end