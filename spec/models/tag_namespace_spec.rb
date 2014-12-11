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
    specify { expect(subject.total_raised_amount_key).to_not be_nil }
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

  describe 'incrby' do
    let(:organization) { create(:organization) }
    let(:tag_namespace) { create(:tag_namespace, organization: organization) }
    let(:amount) { 100 }
    let(:tag_name) { 'foo' }
    let(:tag) { create(:tag, name: tag_name) }

    context 'with one incrby' do
      before(:each) do
        tag_namespace.incrby(amount, tag_name)
      end

      it 'should increment the amounts appropriately' do
        expect(tag_namespace.total_charges_count).to eq(1)
        expect(tag_namespace.total_raised).to eq(100)
        expect(tag_namespace.raised_for_tag(tag)).to eq(100)
        expect(tag_namespace.most_raised).to eq([{:tag=>"foo", :raised=>100}])
      end
    end

    context 'with multiple increments' do
      before(:each) do
        tag_namespace.incrby(amount, tag_name)
        tag_namespace.incrby(amount, tag_name)
        tag_namespace.incrby(amount, tag_name)
        tag_namespace.incrby(50, 'bar')
      end

      it 'should increment the amounts appropriately' do
        expect(tag_namespace.total_charges_count).to eq(4)
        expect(tag_namespace.total_raised).to eq(350)
        expect(tag_namespace.raised_for_tag(tag)).to eq(300)
        expect(tag_namespace.charges_count_last_7_days.to_a.first[1]).to eq(0)
        expect(tag_namespace.charges_count_last_7_days.to_a.last[1]).to eq(4)
        expect(tag_namespace.raised_last_7_days.to_a.last[1]).to eq(350)
        expect(tag_namespace.raised_for_tag(Tag.find_or_create!(organization, 'bar'))).to eq(50)
        expect(tag_namespace.most_raised).to eq([{:tag=>"foo", :raised=>300}, {:tag=>"bar", :raised=>50}])
      end
    end

    after(:each) do
      PragueServer::Application.redis.flushall
    end
  end

  describe 'charges' do
    let!(:organization) { create(:organization) }
    let!(:namespace) { create(:tag_namespace, organization: organization)}
    let!(:tag) { create(:tag, name: 'foo', organization: organization, namespace: namespace) }
    let!(:charge) { create(:charge, organization: organization)}

    before(:each) do
      charge.tags << tag
    end

    it 'should have charges' do
      expect(tag.charges).to eq([charge])
      expect(namespace.charges).to eq([charge])
    end
  end
end
