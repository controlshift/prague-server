require 'spec_helper'

describe "Organization signs up" do
  before(:each) do |example|
    Organization.last.try :destroy
    Crm.last.try :destroy
  end
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
      OrganizationStripeInformationWorker.any_instance.stub(:perform)
    end

    it "redirects to the show page and exposes the organization's API slug" do
      visit new_organization_path
      page.first('#stripe-connect-link').click
      page.should have_text(Organization.last.name)
      slug = Organization.last.slug
      page.should have_text(slug)
      current_path.should == organization_path(slug)
    end
  end
end
