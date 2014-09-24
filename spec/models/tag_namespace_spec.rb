# == Schema Information
#
# Table name: tag_namespaces
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  namespace       :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe TagNamespace do
  it { should have_many :tags }
  it { should belong_to :organization}
  it { should validate_presence_of :namespace }
  it { should validate_presence_of :organization }

  context 'stubbed' do
    subject { build_stubbed(:tag_namespace) }
    specify { expect(subject.most_raised_key).to_not be_nil }
  end

  describe 'find_or_create!' do
    let(:organization) { create(:organization) }
    let(:namespace) { 'foo' }

    context 'no namespace' do
      it 'should create a new namespace for the organization' do
        space = TagNamespace.find_or_create!(organization, namespace)
        expect(space).to_not be_nil
        expect(space.namespace).to eq(namespace)
        expect(space.organization).to eq(organization)
      end
    end

    context 'pre-existing namespace' do
      let!(:space) { create(:tag_namespace, organization: organization, namespace: namespace) }

      it 'should create a new namespace for the organization' do
        expect(TagNamespace.find_or_create!(organization, namespace)).to eq(space)
      end
    end
  end
end
