require 'spec_helper'

describe OrganizationUpdatedWorker do
  let(:organization) { create(:organization) }
  let!(:webhook) { create(:webhook_endpoint, organization: organization)}

  describe 'perform' do
    it 'should accept a request' do
      expect(HTTParty).to receive(:post)
      OrganizationUpdatedWorker.new.perform(organization.id)
    end
  end
end