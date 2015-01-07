class WebhookEndpoint < ActiveRecord::Base
  belongs_to :organization

  validates :url, presence: true, uniqueness: { :scope => :organization_id }
  validates :name, presence: true, uniqueness: { :scope => :organization_id }
end
