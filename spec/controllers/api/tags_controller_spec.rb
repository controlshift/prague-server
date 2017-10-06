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
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).first).to eq('foo')
    end
  end

  describe 'show' do
    it 'responds with 200' do
      get :show, params: { id: 'foo' }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['name']).to eq('foo')
    end

    it 'should include the display amount for the total' do
      get :show, params: { id: 'foo' }
      expect(JSON.parse(response.body)).to have_key('total_raised_display_amount')
    end

    it 'should include the base and display average charge amount' do
      get :show, params: { id: 'foo' }
      expect(JSON.parse(response.body)).to have_key('average_charge_amount')
      expect(JSON.parse(response.body)).to have_key('average_charge_display_amount')
    end
  end


  describe 'history' do
    it 'responds with 200' do
      get :history, params: { id: 'foo', days: 7 }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['name']).to eq('foo')
    end

    it 'should include historical data' do
      get :history, params: { id: 'foo' }
      json = JSON.parse(response.body)
      expect(json).to have_key('charges_count')
      expect(json).to have_key('raised_amount')
    end
  end
end
