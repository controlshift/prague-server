require 'spec_helper'

describe OrganizationsController do
  let(:organization) { create(:organization, global_defaults: { currency: 'AUD' }) }
  let(:user) { create(:confirmed_user, organization: organization)}
  let(:account) { Stripe::Account.create }

  context 'while signed in as an org admin' do
    before(:each) do
      sign_in user
    end

    describe 'GET show' do
      before(:each) do
        StripeMock.start
        organization.stripe_user_id = account.id
        organization.save!
        get :show, params: { id: organization }
      end

      after(:each) { StripeMock.stop }

      it 'should show an organization' do
        expect(response).to render_template(:show)
        expect(assigns(:organization)).to eq(organization)
      end
    end

    describe 'deauthorize' do
      let(:organization) { create(:organization, access_token: 'foo') }
      before(:each) do
        put :deauthorize, params: { id: organization }
      end

      it 'should show an organization' do
        expect(response).to redirect_to(organization)
        expect(assigns(:organization).access_token).to be_nil
      end
    end

    describe 'toggle' do
      context 'test mode false' do
        let(:organization) { create(:organization, testmode: false) }
        before(:each) do
          patch :toggle, params: { id: organization, organization: { testmode: true } }, format: 'js'
        end

        it 'should toggle to true' do
          expect(assigns(:organization).testmode).to be_truthy
        end
      end
    end
  end

  context 'while signed in as another user' do
    before(:each) do
      sign_in create(:confirmed_user)
    end

    it 'should be unauthorized' do
      get :show, params: { id: organization }
      expect(response).to be_redirect
    end
  end
end
