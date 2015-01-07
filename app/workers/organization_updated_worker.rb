class OrganizationUpdatedWorker
  include Sidekiq::Worker

  KIND = 'organization.updated'

  def perform(id)
    organization = Organization.find(id)
    event = { kind: KIND }
    organization.webhook_endpoints.each do |hook|
      Rails.logger.debug "Notifying #{hook.url} of #{KIND}"
      HTTParty.post(hook.url, body: {event: event})
    end
  end

end