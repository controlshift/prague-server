class OrganizationUpdatedWorker
  include Sidekiq::Worker

  KIND = 'organization.updated'

  def perform(id)
    organization = Organization.find(id)
    event = { kind: KIND }
    organization.webhook_endpoints.each do |hook|
      Rails.logger.debug "Notifying #{hook.url} of #{KIND}"

      params = {body: {event: event}}

      # parse the uri to get auth
      uri = URI.parse(hook.url)
      if uri.userinfo.present?
        params.merge!(basic_auth: {:username => uri.password, :password => uri.user} )
      end

      response = HTTParty.post(hook.url, params)
      unless response.body =~ /OK/
        Rails.logger.warn "#{KIND} #{response.body}"
      end
    end
  end
end