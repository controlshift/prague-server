module StripeWebhook
  class Deauthorized
    def call(event)
      organizations = Organization.where(stripe_user_id: event['user_id'])
      organizations.each do |organization|
        Rails.logger.debug "StripeWebhook: Deauthorizing #{organization.slug}"
        organization.update_attributes!(stripe_user_id: nil, stripe_publishable_key: nil, access_token: nil)
      end
    end
  end
end