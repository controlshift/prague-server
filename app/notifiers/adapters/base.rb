module Adapters
  class Base < ::ApplicationAction
    include GoingPostal

    attr_accessor :charge

    def country
      charge.customer.country
    end

    def zip
      charge.customer.zip
    end

    def formatted_zip
      if country
        fp = format_postcode(zip, country)
        fp.present? ? fp : zip
      else
        match = zip.match /(\d\d\d\d\d)\s?-?\s?(\d\d\d\d)/
        if match
          "#{match[1]}-#{match[2]}"
        else
          match = zip.match /(\d\d\d\d\d)?-/
          if match
            "#{match[1]}"
          else
            zip.strip
          end
        end
      end
    end
  end
end