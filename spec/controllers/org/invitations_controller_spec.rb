require 'spec_helper'

describe Org::InvitationsController do
  let(:organization) { create(:organization)}
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    sign_in user
  end

  describe 'create' do
    it 'should successfully create an invitation' do
      email = double()
      expect(email).to receive(:deliver)
      expect(InvitationMailer).to receive(:invitation_email).and_return(email)
      post :create, organization_id: organization, invitation: { recipient_email: 'foo@bar.com'}, format: 'json'
      expect(response).to be_success
    end

    it 'should respond with an error status' do
      expect(InvitationMailer).to_not receive(:invitation_email)
      post :create, organization_id: organization, invitation: { recipient_email: ''}, format: 'json'
      expect(response).to_not be_success
    end
  end
end