module HasSlug
  extend ActiveSupport::Concern

  included do
    before_validation :create_slug!
    validates :slug, uniqueness: true
  end

  def to_param
    slug
  end
  
  def create_slug!
    return slug unless slug.blank?
    update_slug!
  end

  def update_slug!
    field =  self.respond_to?(:title) ? title : name
    parameterized_name = field.blank? ? 'default-slug' : field.parameterize
    self.slug = parameterized_name
    counter = 1
    while (self.class.find_by_slug(slug))
      self.slug = "#{parameterized_name}-#{counter}"
      counter += 1
    end
    slug
  end

end
