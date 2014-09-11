require 'spec_helper'

describe Api::TagsController do
  describe 'show' do
    let(:organization) { create(:organization) }
    let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

    before do
      allow(controller).to receive(:doorkeeper_token) {token}
    end

    let!(:tag) { create(:tag, name: 'foo', organization: organization) }

    it 'responds with 200' do
      get :show, id: 'foo'
      response.status.should eq(200)
      expect(JSON.parse(response.body)['name']).to eq('foo')
    end
  end
end