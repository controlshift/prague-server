require 'spec_helper'

describe Api::ChargesController do
  describe 'index' do
    let(:organization) { create(:organization) }
    let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

    before do
      allow(controller).to receive(:doorkeeper_token) {token}
    end

    let!(:charge) { create(:charge, organization: organization) }

    it 'responds with 200' do
      get :index
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).first['amount']).to eq(charge.amount.to_s)
    end
  end
end