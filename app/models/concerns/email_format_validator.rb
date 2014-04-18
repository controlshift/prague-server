class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[A-Z0-9._+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
      record.errors[attribute] << (options[:message] || I18n.t('errors.messages.email_not_valid'))
    end
  end
end