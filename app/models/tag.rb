# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  namespace_id    :integer
#

class Tag < ActiveRecord::Base
  belongs_to :organization
  belongs_to :namespace, class_name: 'TagNamespace', foreign_key: 'namespace_id'
  has_and_belongs_to_many :charges

  validates :organization, presence: true
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9-]+(:[a-zA-Z0-9-]+)?\z/ }, uniqueness: {scope: 'organization_id' }

  def self.find_or_create!(organization, name)
    return nil if name.blank?
    tag = organization.tags.where(name: name).first
    if tag.nil?
      namespace = TagNamespace.find_or_create!(organization, name.split(':').first)
      tag = Tag.create!(name: name, organization: organization, namespace: namespace)
    end
    tag
  end

  def to_param
    name
  end

  def incrby(amount, status='live')
    DateAggregation.new(total_charges_count_key).increment
    DateAggregation.new(total_raised_amount_key).increment(amount)
    redis.incr(total_charges_count_key(status))
    redis.incrby(total_raised_amount_key(status), amount)
    if namespace.present?
      namespace.incrby(amount, name, status)
    end
  end

  def reset_redis_keys!
    redis.del(total_raised_amount_key, total_charges_count_key)
  end

  def total_raised(status='live')
    redis.get(total_raised_amount_key(status)).to_i
  end

  def total_charges_count(status='live')
    redis.get(total_charges_count_key(status)).to_i
  end

  def average_charge_amount(status='live')
    count = total_charges_count
    if count == 0
      nil
    else
      total_raised / count
    end
  end

  def raised_history(days)
    DateAggregation.new(total_raised_amount_key).history(days)
  end

  def charges_history(days)
    DateAggregation.new(total_charges_count_key).history(days)
  end

  def raised_last_7_days
    DateAggregation.new(total_raised_amount_key).last_7_days
  end

  def charges_count_last_7_days
    DateAggregation.new(total_charges_count_key).last_7_days
  end

  def total_charges_count_key(status='live')
    "#{organization.to_param}/tags/#{name}/total_charges_key/#{status}"
  end

  def total_raised_amount_key(status='live')
    "#{organization.to_param}/tags/#{name}/total_raised_key/#{status}"
  end

  private

  def redis
    PragueServer::Application.redis
  end
end
