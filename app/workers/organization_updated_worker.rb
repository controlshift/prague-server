class OrganizationUpdatedWorker
  include Sidekiq::Worker

  KIND = 'organization.updated'

  def perform(id)
    organization = Organization.find(id)
    event = { kind: KIND }
    organization.webhook_endpoints.each do |hook|
      Rails.logger.debug "Notifying #{hook.url} of #{KIND}"

      params = {body: {event: event}}

      if hook.username.present? && hook.password.present?
        params.merge!(basic_auth: {:username => hook.username, :password => hook.password} )
      end

      response = HTTParty.post(hook.url, params)
      unless response.body =~ /OK/
        Rails.logger.warn "#{KIND} #{response.body}"
      end
    end
  end
end