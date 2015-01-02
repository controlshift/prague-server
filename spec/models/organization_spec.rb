# == Schema Information
#
# Table name: organizations
#
#  id                          :integer          not null, primary key
#  access_token                :string(255)
#  stripe_publishable_key      :string(255)
#  stripe_user_id              :string(255)
#  name                        :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  slug                        :string(255)
#  global_defaults             :hstore
#  testmode                    :boolean
#  refresh_token               :string(255)
#  stripe_live_mode            :boolean
#  stripe_publishable_test_key :string(255)
#  stripe_test_access_token    :string(255)
#

require 'spec_helper'

describe Organization do
  it { should have_many :namespaces }
  it { should have_many :tags }
  it { should have_many :users }
  it { should have_many :invitations }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :slug }

  let(:organization) { build(:organization) }

  it 'should have a default currency' do
    expect(organization.currency).to eq('USD')
  end

  describe '#apply_omniauth' do
    specify 'with all valid credentials supplied' do
      organization.apply_omniauth({
        'uid' => 'X',
        'info' => { 'stripe_publishable_key' => 'X' },
        'credentials' => { 'token' => 'X' }
        })
      organization.should be_valid
      organization.access_token.should == 'X'
      organization.stripe_publishable_key.should == 'X'
      organization.stripe_user_id.should == 'X'
    end

    specify 'invalid hash' do
      expect { organization.apply_omniauth({}) }.to_not raise_error
    end

    specify 'omniauth hash not provided' do
      expect { organization.apply_omniauth(nil) }.to_not raise_error
    end
  end

  describe "#code_snippet" do
    it 'should set the organization for the snippet' do
      organization.save!
      expect(organization.code_snippet.organization).to eq(organization)
    end

    it "should use the organization's seed amount" do
      organization.seedamount = '20'
      organization.save!
      expect(organization.code_snippet.seedamount).to eq('20')
    end

    it "should use the organization's seed values" do
      organization.seedvalues = '1,2,3,4,5,6,7'
      organization.save!
      expect(organization.code_snippet.seedvalues).to eq('1,2,3,4,5,6,7')
    end

    it "should use the organisation's default currency" do
      organization.currency = 'GBP'
      organization.save!
      expect(organization.code_snippet.currency).to eq('GBP')
    end

    it 'should not be in test mode if not specified' do
      organization.save!
      expect(organization.code_snippet.testmode).to be_false
    end

    it 'should not be in test mode if organization is not' do
      organization.testmode = false
      organization.save!
      expect(organization.code_snippet.testmode).to be_false
    end

    it 'should be in test mode if organization is' do
      organization.testmode = true
      organization.save!
      expect(organization.code_snippet.testmode).to be_true
    end

    it 'should default to no tags if none are specified' do
      organization.save!
      expect(organization.code_snippet.tags).to be_empty
    end

    it 'should include tags that are passed in' do
      organization.save!
      expect(organization.code_snippet(tags: ['foo', 'bar-1']).tag_names).to eq(['foo', 'bar-1'])
    end
  end

  describe "#flush_cache_key!" do
    before(:each) do
      organization.save
    end

    it 'should delete the cache object on save' do
      Rails.cache.should_receive(:delete).with("global_defaults_#{organization.slug.downcase}")
      organization.save!
    end
  end

  describe 'global_defaults_for_slug' do
    before(:each) do
      stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
    end

    let!(:organization) { create(:organization, slug: 'slug', global_defaults: { 'foo' => 'bar', currency: 'USD' }) }

    it 'should return a hash' do
      Organization.global_defaults_for_slug('slug').to_json.should == { :foo => 'bar', currency: 'USD', :rates => { 'GBP' => 1.1234 }}.to_json
    end

    context 'with a cached value' do
      before(:each) do
        Rails.cache.write('global_defaults_slug', 'foo')
      end

      it 'should return the cached value if present' do
        Organization.global_defaults_for_slug('slug').should == 'foo'
      end
    end
  end

  describe 'has_slug' do
    let(:organization) { build(:organization, name: 'Title') }

    it 'should set the slug' do
      organization.create_slug!
      organization.slug.should == 'title'
    end

    context 'slug already exits' do
      let(:organization) { build(:organization, name: 'Title', slug: 'foo') }

      it 'should not set the slug' do
        organization.create_slug!
        organization.slug.should == 'foo'
      end
    end

    context 'an existing slug' do
      before(:each) do
        create(:organization, name: 'Title')
      end

      it 'should set the slug' do
        organization.create_slug!
        organization.slug.should == 'title-1'
      end
    end
  end

  describe 'seedamount' do
    context 'entered as an integer' do
      subject { build(:organization, global_defaults: { seedamount: "10", currency: 'USD'} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { seedamount: "1a0a", currency: 'USD'} ) }
      it { should_not be_valid }
    end
  end

  describe 'seedvalues' do
    context 'entered as an integer list' do
      subject { build(:organization, global_defaults: { seedvalues: "10,20,30", currency: 'USD'} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { seedvalues: "1234a", currency: 'USD'} ) }
      it { should_not be_valid }
    end
  end

  describe 'redirectto' do
    context 'entered as a url' do
      subject { build(:organization, global_defaults: { redirectto: "www.google.com", currency: 'USD'} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { redirectto: "1234a", currency: 'USD'} ) }
      it { should_not be_valid }
    end
  end

  describe 'testmode' do
    context 'in testmode' do
      subject { build(:organization, testmode: true ) }
      specify { subject.status.should == 'test' }
    end

    context 'in live mode' do
      subject { build(:organization, testmode: false ) }
      specify { subject.status.should == 'live' }
    end
  end

  describe 'currency dirty tracking' do
    let(:organization) { create(:organization, global_defaults: { currency: 'USD'}) }
    it 'should be possible to track dirty hstore' do
      expect(organization.currency).to eq('USD')
      expect(organization.currency_changed?).to be_false
      organization.currency = 'GBP'
      expect(organization.currency_changed?).to be_true
      organization.save!
      expect(organization.currency_changed?).to be_false
    end

    it 'should not be changed if the currency stays the same' do
      expect(organization.currency_changed?).to be_false
      organization.currency = 'USD'
      expect(organization.currency_changed?).to be_false
    end
  end

  describe 'currency changes' do
    let!(:organization) { create(:organization) }
    let!(:charge) { create(:charge, organization: organization, amount: 100, paid: true, status: 'live') }
    let!(:tag) { create(:tag, name: 'foo', organization: organization, namespace: namespace) }
    let!(:namespace) { create(:tag_namespace, organization: organization) }

    before(:each) do
      Charge.any_instance.stub(:rate_conversion_hash).and_return('GBP' => 1, 'USD' => 2)

      charge.tags << tag
      tag.incrby(charge.amount)
    end

    it 'should allow the reset of redis keys' do
      organization.tags.find_each do |tag|
        tag.reset_redis_keys!
      end

      organization.namespaces.find_each do |namespace|
        namespace.reset_redis_keys!
      end

      expect(namespace.total_charges_count).to eq(0)
      expect(namespace.total_raised).to eq(0)
      expect(namespace.raised_for_tag(tag)).to eq(0)
      expect(namespace.most_raised).to eq([])
    end

    it 'should recalculate aggregates in the new currency' do
      expect(namespace.total_charges_count).to eq(1)
      expect(namespace.total_raised).to eq(100)
      expect(namespace.raised_for_tag(tag)).to eq(100)
      expect(namespace.most_raised).to eq([{:tag=>"foo", :raised=>100}])

      organization.update_attributes(currency: 'GBP')
      expect(organization.reload.currency).to eq('GBP')

      expect(namespace.total_charges_count).to eq(1)
      expect(namespace.total_raised).to eq(50)
      expect(namespace.raised_for_tag(tag)).to eq(50)
      expect(namespace.most_raised).to eq([{:tag=>"foo", :raised=>50}])
    end

    after(:each) do
      PragueServer::Application.redis.flushall
    end
  end
end
