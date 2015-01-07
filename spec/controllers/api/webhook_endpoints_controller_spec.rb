require 'spec_helper'

describe Api::WebhookEndpointsController do
  render_views

  let(:organization) { create(:organization) }
  let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  describe '#index' do
    let(:webhook_endpoint) { create(:webhook_endpoint, organization: organization) }

    it 'should let you get the webhooks' do
      get :index
      expect(response).to be_success
    end
  end

  describe '#create' do
    it 'should allow creation of webhook endpoints' do
      post :create, webhook_endpoint: { name: 'foo', url: 'https://www.google.com/'}
      expect(assigns(:webhook).name).to eq('foo')
      expect(assigns(:webhook).url).to eq('https://www.google.com/')
    end

    it 'should not allow creation of invalid webhook endpoints' do
      post :create, webhook_endpoint: { name: '', url: 'https://www.google.com/'}
      expect(assigns(:webhook).persisted?).to be_false
    end
  end
end