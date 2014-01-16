require 'spec_helper'

describe Organization do

  it { should validate_presence_of :stripe_user_id }
  it { should validate_presence_of :stripe_publishable_key }
  it { should validate_presence_of :access_token }

  let(:organization) { build(:organization) }

  describe '#update_account_information_from_stripe!' do
    specify 'it should kick off a job :after_create' do
      OrganizationStripeInformationWorker.should_receive(:perform_async)
      organization.save!
    end
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
end