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
    redis.incr(total_charges_count_key)
    redis.incrby(total_raised_amount_key, amount)
    if namespace.present?
      namespace.incrby(amount, name, status)
    end
  end

  def total_raised
    redis.get(total_raised_amount_key).to_i
  end

  def total_charges_count
    redis.get(total_charges_count_key).to_i
  end

  private

  def total_charges_count_key(status='live')
    "#{organization.to_param}/tags/#{name}/total_charges_key/#{status}"
  end

  def total_raised_amount_key(status='live')
    "#{organization.to_param}/tags/#{name}/total_raised_key/#{status}"
  end

  def redis
    PragueServer::Application.redis
  end
end
