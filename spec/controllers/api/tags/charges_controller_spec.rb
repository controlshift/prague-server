require 'spec_helper'

describe Api::Tags::ChargesController do
  render_views

  let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  let(:organization) { create(:organization) }
  let!(:tag) { create(:tag, name: 'foo', organization: organization) }
  let!(:charge) { create(:charge, organization: organization, paid: true)}

  describe 'index' do
    before(:each) do
      charge.tags << tag
    end

    it 'should get a list of charges in the namespace' do
      get :index, tag_id: tag.name
      expect(response).to be_success
      expect(JSON.parse(response.body).first['amount'].to_i).to eq(charge.amount)
    end
  end
end