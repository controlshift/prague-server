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
      get :show, params: { id: 'foo' }
      expect(response.status).to eq(200)
      expect(assigns(:namespace)).to eq(namespace)
      expect(JSON.parse(response.body)['namespace']).to eq('foo')
    end
  end

  describe 'history' do
    it 'responds with 200' do
      get :history, params: { id: 'foo', days: 7 }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['namespace']).to eq('foo')
    end

    it 'should include historical data' do
      get :history, params: { id: 'foo' }
      json = JSON.parse(response.body)
      expect(json).to have_key('charges_count')
      expect(json).to have_key('raised_amount')
    end
  end

  describe 'index' do
    it 'responds with 200' do
      get :index
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).first).to eq('foo')
    end
  end

  describe 'raised' do
    let(:most_raised_tag) { create(:tag, organization: organization, namespace: namespace) }
    let(:second_most_raised_tag) { create(:tag, organization: organization, namespace: namespace) }

    before :each do
      most_raised_tag.incrby(1000)
      second_most_raised_tag.incrby(500)
    end

    it 'responds with 200' do
      get :raised, params: { id: namespace }

      expect(response.status).to eq(200)
    end

    it "returns top ranked tags" do
      get :raised, params: { id: namespace }

      most_raised_tags = JSON.parse(response.body)

      expect(most_raised_tags.count).to eq 2
      expect(most_raised_tags[0]['tag']).to eq most_raised_tag.name
      expect(most_raised_tags[0]['raised']).to eq most_raised_tag.total_raised
      expect(most_raised_tags[0]['raised_display_amount']).to eq Charge.presentation_amount(most_raised_tag.total_raised, organization.currency)
      expect(most_raised_tags[0]['currency']).to eq organization.currency
      expect(most_raised_tags[1]['tag']).to eq second_most_raised_tag.name
      expect(most_raised_tags[1]['raised']).to eq second_most_raised_tag.total_raised
      expect(most_raised_tags[1]['raised_display_amount']).to eq Charge.presentation_amount(second_most_raised_tag.total_raised, organization.currency)
      expect(most_raised_tags[1]['currency']).to eq organization.currency
    end
  end
end