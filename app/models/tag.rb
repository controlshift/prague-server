class Tag < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :charges

  validates :organization, presence: true
  validates :name, presence: true

  def self.find_or_create!(organization, name)
    tag = organization.tags.where(name: name).first
    if tag.nil?
      tag = Tag.create!(name: name, organization: organization)
    end
    tag
  end

  def to_param
    name
  end
end
