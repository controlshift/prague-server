describe Api::ConfigController do
  describe 'GET #show' do
    let(:organization) { create(:organization) }
    let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

    before do
      allow(controller).to receive(:doorkeeper_token) {token}
    end

    it 'responds with 200' do
      get :show, :format => :json
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['slug']).to eq(organization.slug)
    end
  end
end