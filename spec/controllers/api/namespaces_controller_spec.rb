require 'spec_helper'

describe Api::NamespacesController do
  render_views

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
      expect(assigns(:namespace)).to eq(namespace)
      expect(JSON.parse(response.body)['namespace']).to eq('foo')
    end
  end

  describe 'history' do
    it 'responds with 200' do
      get :history, id: 'foo', days: 7
      response.status.should eq(200)
      expect(JSON.parse(response.body)['namespace']).to eq('foo')
    end

    it 'should include historical data' do
      get :history, id: 'foo'
      json = JSON.parse(response.body)
      expect(json).to have_key('charges_count')
      expect(json).to have_key('raised_amount')
    end
  end

  describe 'index' do
    it 'responds with 200' do
      get :index
      response.status.should eq(200)
      expect(JSON.parse(response.body).first).to eq('foo')
    end
  end

  describe 'raised' do
    it 'responds with 200' do
      get :raised, id: 'foo'
      response.status.should eq(200)
      expect(JSON.parse(response.body)).to eq([])
    end
  end
end