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
  validates :namespace, presence: true, uniqueness: {scope: 'organization_id' }
  validates :organization, presence: true

  has_many :tags, foreign_key: 'namespace_id'
  belongs_to :organization
  has_many :charges, through: :tags

  def self.find_or_create!(organization, name)
    namespace = where(namespace: name, organization: organization).first
    if namespace.nil?
      namespace = TagNamespace.create!(namespace: name, organization: organization)
    end
    namespace
  end

  def incrby(amount, name, status='live')
    redis.zincrby(self.most_raised_key(status), amount, name)
    redis.incrby(self.total_raised_amount_key(status), amount)
    redis.incr(self.total_charges_count_key(status))
  end

  def total_raised(status='live')
    redis.get(total_raised_amount_key(status)).to_i
  end

  def raised_for_tag(tag, status='live')
    redis.zscore(most_raised_key(status), tag.name).to_i
  end

  def most_raised(status='live')
    tags_with_scores = redis.zrevrange(most_raised_key(status), 0, -1, with_scores: true)
    tags_with_scores.collect{|t| {tag: t.first, raised: t.last.to_i }} # convert the score (amount raised) to integer value.
  end

  def total_charges_count(status='live')
    redis.get(total_charges_count_key(status)).to_i
  end

  def total_charges_count_key(status='live')
    "#{organization.to_param}/namespaces/#{namespace}/total_charges_key/#{status}"
  end

  def total_raised_amount_key(status='live')
    "#{organization.to_param}/namespaces/#{namespace}/total_raised_key/#{status}"
  end

  def most_raised_key(status='live')
    "#{organization.to_param}/namespaces/#{namespace}/most_raised_tags/#{status}"
  end

  def to_param
    namespace
  end

  private

  def redis
    PragueServer::Application.redis
  end
end
