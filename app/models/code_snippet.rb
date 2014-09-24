class CodeSnippet
  include ActiveModel::Model

  attr_accessor :organization, :seedamount, :seedvalues, :tags, :currency, :testmode

  def tag_names
    tags.map { |tag| tag.name }
  end

  def serialized_tags
    tag_names.join(',')
  end

  def to_html
    "<script src=\"#{ENV['CLIENT_CLOUDFRONT_DISTRIBUTION']}\" id=\"donation-script\" data-org=\"#{organization.slug}\"
      data-seedamount=\"#{ seedamount || '10'}\" data-seedvalues=\"#{ seedvalues || '50,100,200,300,400,500,600' }\"
      data-tags=\"#{serialized_tags}\"
      data-seedcurrency=\"#{ currency || "USD"}\" #{ "data-chargestatus=\"test\"" if testmode }></script>".squish
  end
end
