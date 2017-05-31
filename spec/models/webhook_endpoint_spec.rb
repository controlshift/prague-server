# == Schema Information
#
# Table name: webhook_endpoints
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  url             :text
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#  username        :string
#  password        :string
#

require 'spec_helper'

describe WebhookEndpoint do
  it { should validate_presence_of :url }
  it { should validate_presence_of :name }
  it { should belong_to :organization }
  it { should allow_value('http://localhost/').for(:url)}
end
