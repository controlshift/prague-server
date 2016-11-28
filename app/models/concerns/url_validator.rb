class UrlValidator < ActiveModel::EachValidator
  URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/

  def validate_each(object, attribute, value)
    if value.present? && !URL_REGEX.match(value)
      object.errors[attribute] << I18n.t('errors.messages.url.format')
    end
  end
end
