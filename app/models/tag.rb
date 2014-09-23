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
  validates :name, presence: true

  def self.find_or_create!(organization, name)
    tag = organization.tags.where(name: name).first
    if tag.nil?
      namespace = TagNamespace.find_or_create!(name.split(':').first)
      tag = Tag.create!(name: name, organization: organization, namespace: namespace)
    end
    tag
  end

  def to_param
    name
  end
end
