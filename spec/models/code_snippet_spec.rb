require 'spec_helper'

describe CodeSnippet do
  let (:organization) { create(:organization, slug: 'some-slug') }
  let (:snippet) { organization.code_snippet }

  describe '#to_html' do
    it 'should be a script tag' do
      expect(snippet.to_html).to include('script')
    end

    it 'should include the organization\'s slug' do
      expect(snippet.to_html).to include(organization.slug)
    end

    it 'should default to a seed amount of 10' do
      expect(snippet.to_html).to include('data-seedamount="10"')
    end

    it 'should use the seed amount specified' do
      snippet.seedamount = '20'
      expect(snippet.to_html).to include('data-seedamount="20"')
    end

    it 'should use default seed values if not specified' do
      expect(snippet.to_html).to include('data-seedvalues="50,100,200,300,400,500,600"')
    end

    it 'should use the seed values specified' do
      snippet.seedvalues = '1,2,3,4,5,6,7'
      expect(snippet.to_html).to include('data-seedvalues="1,2,3,4,5,6,7"')
    end

    it "should default to USD" do
      expect(snippet.to_html).to include('data-seedcurrency="USD"')
    end

    it 'should use the currency specified' do
      snippet.currency = 'GBP'
      expect(snippet.to_html).to include('data-seedcurrency="GBP"')
    end

    it 'should not be in test mode if not specified' do
      expect(snippet.to_html).not_to include('data-chargestatus="test"')
    end

    it 'should not be in test mode if specified not' do
      snippet.testmode = false
      expect(snippet.to_html).not_to include('data-chargestatus="test"')
    end

    it 'should be in test mode if specified' do
      snippet.testmode = true
      expect(snippet.to_html).to include('data-chargestatus="test"')
    end

    it 'should default to no tags if none are specified' do
      expect(snippet.to_html).to include('data-tags=""')
    end

    it 'should include tags that are passed in' do
      snippet.tags = ['foo', 'bar-1'].map { |tag_name| Tag.find_or_create!(organization, tag_name) }
      expect(snippet.to_html).to include('data-tags="foo,bar-1"')
    end
  end
end
