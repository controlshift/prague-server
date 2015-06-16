require 'spec_helper'

describe Api::CodeSnippetController do
  let(:organization) { create(:organization) }
  let(:token) { double :accessible? => true, :acceptable? => true, resource_owner_id: organization.id }

  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  describe '#show' do
    it 'responds with 200' do
      get :show
      expect(response.status).to eq(200)
      expect(response.body).to eq(organization.code_snippet.to_html)
    end

    it 'includes the specified tags in the code snippet' do
      get :show, tags: 'foo,bar-1,baz-1-2-3'
      expect(response.body).to eq(organization.code_snippet(tags: ['foo', 'bar-1', 'baz-1-2-3']).to_html)
    end

    it 'raises an error if passed invalid tags' do
      expect {
        get :show, tags: ['alert("I am doing something unsavoury!");\\\\']
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#parameters' do
    it 'responds with 200' do
      get :parameters
      expect(response.status).to eq(200)
      expect(response.body).to eq(JSON::dump(organization.code_snippet.params))
    end

    it 'includes the specified tags in the code snippet' do
      get :parameters, tags: 'foo,bar-1,baz-1-2-3'
      expect(JSON::load(response.body)['data-tags']).to eq('foo,bar-1,baz-1-2-3')
    end

    it 'raises an error if passed invalid tags' do
      expect {
        get :parameters, tags: ['alert("I am doing something unsavoury!");\\\\']
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
