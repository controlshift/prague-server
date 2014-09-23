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
  has_many :tags, foreign_key: 'namespace_id'

  def self.find_or_create!(name)
    namespace = where(namespace: name).first
    if namespace.nil?
      namespace = TagNamespace.create!(namespace: name)
    end
    namespace
  end

  def best_tags_key
    "most_raised_tags/#{namespace}"
  end
end
