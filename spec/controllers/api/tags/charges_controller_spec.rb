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
      get :index, params: { tag_id: tag.name }
      expect(response).to be_success
      expect(JSON.parse(response.body).first['amount'].to_i).to eq(charge.amount)
    end

    it 'should include the display amount' do
      get :index, params: { tag_id: tag.name }
      expect(JSON.parse(response.body).first).to have_key('display_amount')
    end

    it 'should include the list of all tags for each charge' do
      get :index, params: { tag_id: tag.name }
      json_response = JSON.parse(response.body)
      expect(json_response.first['tags']).to eq(['foo'])
    end

    it 'should include the stripe dashboard url' do
      get :index, params: { tag_id: tag.name }
      expect(JSON.parse(response.body).first).to have_key('stripe_url')
    end

    context 'charge is in a different currency' do
      let!(:charge) { create(:charge, currency: 'GBP', organization: organization, paid: true)}

      it 'should include the displayable converted amount in the org currency' do
        get :index, params: { tag_id: tag.name }
        expect(JSON.parse(response.body).first['display_amount_in_org_currency']).to eq Charge.presentation_amount(charge.converted_amount(organization.currency), organization.currency)
      end
    end
  end
end
