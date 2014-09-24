# == Schema Information
#
# Table name: tag_namespaces
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  namespace       :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class TagNamespace < ActiveRecord::Base
  validates :namespace, presence: true
  validates :organization, presence: true

  has_many :tags, foreign_key: 'namespace_id'
  belongs_to :organization

  def self.find_or_create!(organization, name)
    namespace = where(namespace: name, organization: organization).first
    if namespace.nil?
      namespace = TagNamespace.create!(namespace: name, organization: organization)
    end
    namespace
  end

  def incrby(amount, name)
    redis.zincrby(self.most_raised_key, amount, name)
    redis.incrby(self.total_raised_key, amount)
  end

  def total_raised
    redis.get(total_raised_key)
  end

  def total_raised_key
    "#{organization.to_param}/total_raised_key/#{namespace}"
  end

  def most_raised_key
    "#{organization.to_param}/most_raised_tags/#{namespace}"
  end

  private

  def redis
    PragueServer::Application.redis
  end
end
