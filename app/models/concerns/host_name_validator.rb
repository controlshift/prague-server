require 'resolv'

class HostNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      begin
        Resolv::DNS.new(:nameserver => ['8.8.8.8', '8.8.4.4']).getaddress(value)
      rescue Resolv::ResolvError => e
        record.errors[attribute] << e.message
      end
    end
  end
end