require 'spec_helper'

describe WebhookEndpoint do
  it { should validate_presence_of :url }
  it { should validate_presence_of :name }
  it { should belong_to :organization }
end