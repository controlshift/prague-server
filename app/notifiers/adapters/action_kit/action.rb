module Adapters
  module ActionKit
    class Action < ::Adapters::Base
      attr_accessor :import_stub

      def to_hash
        crm = charge.organization.crm
        charge_amount = import_stub.present? ? charge.converted_amount(crm.default_currency) : charge.amount

        params = config_hash.merge({
          page: charge.config.try(:[], 'page') || crm.donation_page_name,
          email: charge.customer.email,
          name: charge.customer.full_name,
          country: country,
          zip: formatted_zip,
          card_num: '4111111111111111',
          card_code: '007',
          exp_date_month: 1.month.from_now.strftime('%m'),
          exp_date_year: 1.month.from_now.strftime('%y'),
          amount_other: Charge.presentation_amount(charge_amount, charge.currency.upcase),
          action_charge_id: charge.id,
          action_charge_status: charge.status,
          action_charge_currency: charge.currency.upcase
        })

        if import_stub.present?
          params = params.merge({
                                  payment_account: import_stub.payment_account,
                                  currency: import_stub.donation_currency
                                })
        end

        params
      end

      def config_hash
        if charge.config.present?
          charge.config.select { |k,v| k.start_with? "action_" || k == "source" }.merge({ 'orig_akid' => config['akid'] })
        else
          {}
        end
      end
    end
  end
end