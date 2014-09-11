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

    context 'with an existing tag' do
      let(:tag) { create(name: 'foo', organization: organization) }

      it 'should find the tag' do
        expect(Tag.find_or_create!(organization, 'foo').name).to eq('foo')
      end
    end
  end
end