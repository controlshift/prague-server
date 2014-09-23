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
      n = TagNamespace.create(namespace: 'common-thing')
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
  end
end
