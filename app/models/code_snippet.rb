class CodeSnippet
  include ActiveModel::Model
  include ActionView::Helpers

  attr_accessor :organization, :seedamount, :seedvalues, :tags, :currency, :testmode

  def tag_names
    tags.map { |tag| tag.name }
  end

  def serialized_tags
    tag_names.join(',')
  end

  def params
    standard_params = { src: ENV['CLIENT_CLOUDFRONT_DISTRIBUTION'],
                        id: 'donation-script',
                        'data-org' => organization.slug,
                        'data-seedamount' => seedamount || '10',
                        'data-seedvalues' => seedvalues || '50,100,200,300,400,500,600',
                        'data-tags' => serialized_tags,
                        'data-seedcurrency' => currency || 'USD' }
    testmode ? standard_params.merge({'data-chargestatus' => 'test'}) : standard_params
  end

  def to_html
    javascript_tag '', params
  end
end
