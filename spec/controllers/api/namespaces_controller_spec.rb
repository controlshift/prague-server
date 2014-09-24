require 'spec_helper'

describe Api::NamespacesController do
  let(:organization) { create(:organization) }
  let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }
  let!(:namespace) { create(:tag_namespace, namespace: 'foo', organization: organization) }

  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  describe 'show' do
    it 'responds with 200' do
      get :show, id: 'foo'
      response.status.should eq(200)
      expect(JSON.parse(response.body)['namespace']).to eq('foo')
    end
  end

  describe 'index' do
    it 'responds with 200' do
      get :index
      response.status.should eq(200)
      expect(JSON.parse(response.body).first).to eq('foo')
    end
  end
end