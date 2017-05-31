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

class WebhookEndpoint < ActiveRecord::Base
  belongs_to :organization

  validates :url, presence: true,  uniqueness: { :scope => :organization_id }, url: true
  validates :name, presence: true, uniqueness: { :scope => :organization_id }
end
