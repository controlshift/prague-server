# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  namespace_id    :integer
#

require 'spec_helper'

describe Tag do
  it { should have_and_belong_to_many(:charges) }
  it { should validate_presence_of :name }
  it { should belong_to(:organization) }
  it { should belong_to(:namespace)}

  describe 'find_or_create!' do
    let(:organization) { create(:organization) }

    it 'should allow tags to be created' do
      t = Tag.find_or_create!(organization, 'tag')
      t.should be_a(Tag)
      t.name.should eq('tag')
    end

    it 'should create a namespace for a tag with a new namespace' do
      t = Tag.find_or_create!(organization, 'novel-thing:tag')
      t.name.should eq('novel-thing:tag')
      expect(t.namespace).to be_a(TagNamespace)
      expect(t.namespace.namespace).to eq('novel-thing')
    end

    it 'should associate an existing namespace with a tag' do
      n = TagNamespace.create(namespace: 'common-thing', organization: organization)
      t = Tag.find_or_create!(organization, 'common-thing:tag')
      expect(t.namespace).to eq(n)
      expect(n.tags.first).to eq(t)
    end

    context 'with an existing tag' do
      let(:tag) { create(name: 'foo', organization: organization) }

      it 'should find the tag' do
        expect(Tag.find_or_create!(organization, 'foo').name).to eq('foo')
      end
    end

    describe 'incrby' do
      let(:organization) { create(:organization) }
      let(:tag) { create(:tag, name: 'foo', organization: organization) }
      let(:amount) { 100 }
      let(:tag_name) { 'foo' }

      context 'with one incrby' do
        before(:each) do
          tag.incrby(amount)
        end

        it 'should increment the amounts appropriately' do
          expect(tag.total_charges_count).to eq(1)
          expect(tag.total_raised).to eq(100)
        end
      end

      context 'with multiple increments and a namespace' do
        let(:tag_namespace) { create(:tag_namespace, organization: organization)}
        let(:tag) { create(:tag, name: 'foo', organization: organization, namespace: tag_namespace) }
        let(:tag2) { create(:tag, name: 'bar', organization: organization, namespace: tag_namespace) }

        before(:each) do
          tag.incrby(amount)
          tag.incrby(amount)
          tag.incrby(amount)
          tag2.incrby(50)
        end

        it 'should increment the amounts appropriately' do
          expect(tag_namespace.total_charges_count).to eq(4)
          expect(tag_namespace.total_raised).to eq(350)
          expect(tag_namespace.raised_for_tag(tag)).to eq(300)
          expect(tag_namespace.raised_for_tag(tag2)).to eq(50)

          expect(tag2.total_charges_count).to eq(1)
          expect(tag2.total_raised).to eq(50)

          expect(tag.total_charges_count).to eq(3)
          expect(tag.total_raised).to eq(300)
        end
      end

      after(:each) do
        PragueServer::Application.redis.flushall
      end
    end
  end
end
