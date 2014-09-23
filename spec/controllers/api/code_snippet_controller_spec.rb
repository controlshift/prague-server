require 'spec_helper'

describe Api::CodeSnippetController do
  describe 'show' do
    let(:organization) { create(:organization) }
    let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

    before do
      allow(controller).to receive(:doorkeeper_token) {token}
    end

    it 'responds with 200' do
      get :show
      response.status.should eq(200)
      expect(response.body).to eq(organization.code_snippet)
    end

    it 'includes the specified tags in the code snippet' do
      get :show, tags: ['foo', 'bar-1', 'baz-1-2-3']
      expect(response.body).to eq(organization.code_snippet(tags: ['foo', 'bar-1', 'baz-1-2-3']))
    end
  end
end
