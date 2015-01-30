require 'spec_helper'

describe OrganizationUpdatedWorker do
  let(:organization) { create(:organization) }
  let!(:webhook) { create(:webhook_endpoint, organization: organization, username: 'foo', password: 'bar', url: 'https://google.com/')}

  describe 'perform' do
    it 'should accept a request' do
      expect(HTTParty).to receive(:post).with('https://google.com/', {:body=>{:event=>{:kind=>"organization.updated"}}, :basic_auth=>{:username=>"foo", :password=>"bar"}}).and_return(response = double)
      allow(response).to receive(:body).and_return('OK')
      OrganizationUpdatedWorker.new.perform(organization.id)
    end
  end
end