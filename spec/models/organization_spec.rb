# == Schema Information
#
# Table name: organizations
#
#  id                     :integer          not null, primary key
#  access_token           :string(255)
#  stripe_publishable_key :string(255)
#  stripe_user_id         :string(255)
#  name                   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)
#  slug                   :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  global_defaults        :hstore
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

require 'spec_helper'

describe Organization do

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should validate_uniqueness_of :slug }

  let(:organization) { build(:organization) }

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
    it 'should give a snippet that includes the organization\'s slug' do
      organization.save!
      organization.code_snippet.should include("script", organization.slug)
    end
  end

  describe "#flush_cache_key!" do
    it 'should delete the cache object on save' do
      Rails.cache.should_receive(:delete).with("global_defaults_#{organization.name.downcase}")
      organization.save!
    end
  end

  describe 'global_defaults_for_slug' do
    before(:each) do
      stub_request(:get, 'http://platform.controlshiftlabs.com/cached_url/currencies').to_return(body: "{\"rates\":{\"GBP\":1.1234}}")
    end

    let!(:organization) { create(:organization, slug: 'slug', global_defaults: { 'foo' => 'bar' }) }

    it 'should return a hash' do
      Organization.global_defaults_for_slug('slug').to_json.should == { :foo => 'bar', :rates => { 'GBP' => 1.1234 }}.to_json
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
      subject { build(:organization, global_defaults: { seedamount: "10"} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { seedamount: "1a0a"} ) }
      it { should_not be_valid }
    end
  end

  describe 'seedvalues' do
    context 'entered as an integer list' do
      subject { build(:organization, global_defaults: { seedvalues: "10,20,30"} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { seedvalues: "1234a"} ) }
      it { should_not be_valid }
    end
  end

  describe 'redirectto' do
    context 'entered as a url' do
      subject { build(:organization, global_defaults: { redirectto: "www.google.com"} ) }
      it { should be_valid }
    end
    context 'entered as an illegal value' do
      subject { build(:organization, global_defaults: { redirectto: "1234a"} ) }
      it { should_not be_valid }
    end
  end

  describe 'testmode' do
    context 'in testmode' do
      subject { build(:organization, testmode: true ) }
      specify { subject.status == 'test' }
    end

    context 'in live mode' do
      subject { build(:organization, testmode: true ) }
      specify { subject.status == 'live' }
    end
  end
end
