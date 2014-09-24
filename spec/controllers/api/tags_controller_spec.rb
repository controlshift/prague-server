require 'spec_helper'

describe Api::TagsController do
  render_views

  let(:organization) { create(:organization) }
  let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  let!(:tag) { create(:tag, name: 'foo', organization: organization) }

  describe 'index' do
    it 'responds with 200' do
      get :index
      response.status.should eq(200)
      expect(JSON.parse(response.body).first).to eq('foo')
    end
  end

  describe 'show' do
    it 'responds with 200' do
      get :show, id: 'foo'
      response.status.should eq(200)
      expect(JSON.parse(response.body)['name']).to eq('foo')
    end
  end
end