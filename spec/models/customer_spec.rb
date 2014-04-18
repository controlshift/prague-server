require 'spec_helper'

describe Customer do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :country }
  it { should validate_presence_of :zip }

  it { should allow_value('george@washington.com').for(:email) }
  it { should_not allow_value('xxx').for(:email) }
end