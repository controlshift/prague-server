# == Schema Information
#
# Table name: tag_namespaces
#
#  id         :integer          not null, primary key
#  namespace  :string(255)
#  created_at :datetime
#  updated_at :datetime
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

  def most_raised_key
    "most_raised_tags/#{namespace}"
  end
end
