require 'spec_helper'

describe UsersController do
  let(:organization) { create(:organization) }
  let(:user) { create(:confirmed_user, organization: organization) }
  let(:invitation) { create(:invitation, organization: organization, sender: user) }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#new' do
    it 'should be successful on normal new user requests' do
      get :new
      expect(response).to be_success
      expect(assigns(:invitation)).to be_nil
    end

    context 'invitation' do
      it 'should load the invitation' do
        get :new, params: { invitation_token: invitation.token }
        expect(response).to be_success
        expect(assigns(:invitation)).to eq(invitation)
      end

      it 'should redirect if invitation does not exist' do
        get :new, params: { invitation_token: 'foo' }
        expect(response).to be_redirect
      end
    end
  end

  describe '#create' do
    it 'should allow creation' do
      post :create, params: { user: {email: 'george@washington.com', password: 'password', password_confirmation: 'password', organization_attributes: {name: 'George for President' } } }
      expect(response).to be_redirect
    end

    it 'should create with invitation' do
      post :create, params: { user: {email: 'george@washington.com', password: 'password', password_confirmation: 'password' }, invitation_token: invitation.token }
      expect(response).to be_redirect
    end
  end
end