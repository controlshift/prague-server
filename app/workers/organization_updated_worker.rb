class OrganizationUpdatedWorker
  include Sidekiq::Worker

  KIND = 'organization.updated'

  def perform(id)
    organization = Organization.find(id)
    event = { kind: KIND }
    organization.webhook_endpoints.each do |hook|
      Rails.logger.debug "Notifying #{hook.url} of #{KIND}"
      response = HTTParty.post(hook.url, body: {event: event})
      unless response.body =~ /OK/
        Rails.logger.warn "#{KIND} #{response.body}"
      end
    end
  end
end