class OrganizationUpdatedWorker
  include Sidekiq::Worker

  def perform(id)
    organization = Organization.find(id)
    event = { kind: 'organization.updated' }
    organization.webhook_endpoints.each do |hook|
      HTTParty.post(hook.url, body: {event: event})
    end
  end
end